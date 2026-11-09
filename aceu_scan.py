"""Read-only OCI posture checks with offline synthetic fixture support."""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path
from typing import Any
import yaml

ROOT = Path(__file__).parent

def value_at(obj: Any, dotted: str) -> Any:
    current = obj
    for part in dotted.split("."):
        if isinstance(current, dict): current = current.get(part)
        else: current = getattr(current, part, None)
    return current

def violated(rule: dict, resource: Any) -> bool:
    value = value_at(resource, rule.get("path", ""))
    if "contains" in rule:
        values = value if isinstance(value, list) else [value]
        return any(rule["contains"].casefold() in str(v).casefold() for v in values)
    if "not_contains" in rule:
        return rule["not_contains"].casefold() not in str(value or "").casefold()
    if "equals" in rule: return value == rule["equals"]
    if "missing_or_false" in rule:
        nested = value_at(value, rule["missing_or_false"])
        return not bool(nested)
    raise ValueError(f"unsupported predicate in rule {rule.get('id')}")

def load_rules(folder: Path) -> list[dict]:
    return [yaml.safe_load(p.read_text()) for p in sorted(folder.glob("*.yaml"))]

def scan(resources: dict[str, list], rules: list[dict]) -> list[dict]:
    findings=[]
    for rule in rules:
        for resource in resources.get(rule["resource"], []):
            if violated(rule, resource):
                findings.append({"rule":rule["id"],"severity":rule["severity"],"resource":getattr(resource,"id",None) or (resource.get("id") if isinstance(resource,dict) else None),"message":rule["message"],"documentation":rule["documentation"]})
    return findings

def fixture_resources(path: Path) -> dict:
    data=json.loads(path.read_text())
    return data["resources"]

def oci_resources() -> dict:
    try:
        import oci
    except ImportError as e:
        raise RuntimeError("OCI SDK missing; install with `python -m pip install -e '.[dev]'`") from e
    config=oci.config.from_file()
    tenancy=config["tenancy"]
    identity=oci.identity.IdentityClient(config)
    vaults=oci.vault.VaultsClient(config)
    container=oci.artifacts.ArtifactsClient(config)
    return {
      "policies":[x for x in oci.pagination.list_call_get_all_results(identity.list_policies,tenancy).data],
      "dynamic_groups":[x for x in oci.pagination.list_call_get_all_results(identity.list_dynamic_groups,tenancy).data],
      "secrets":[x for x in oci.pagination.list_call_get_all_results(vaults.list_secrets,tenancy).data],
      "container_repositories":[x for x in oci.pagination.list_call_get_all_results(container.list_container_repositories,tenancy).data],
    }

def main(argv=None) -> int:
    parser=argparse.ArgumentParser(description="Read-only OCI posture scan; fixture mode uses synthetic data only")
    parser.add_argument("--fixtures",nargs="?",const=str(ROOT/"fixtures/oci.json"),help="scan synthetic fixture JSON instead of OCI")
    parser.add_argument("--rules",default=str(ROOT/"rules"))
    args=parser.parse_args(argv)
    try:
        resources=fixture_resources(Path(args.fixtures)) if args.fixtures else oci_resources()
        print(json.dumps({"mode":"fixtures" if args.fixtures else "oci-read-only","findings":scan(resources,load_rules(Path(args.rules)))},indent=2))
        return 0
    except Exception as exc:
        print(f"aceu-scan: {exc}",file=sys.stderr); return 2
if __name__=="__main__": raise SystemExit(main())
