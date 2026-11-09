import json
from pathlib import Path
import pytest
from aceu_scan import load_rules, scan

ROOT=Path(__file__).parents[1]
RULES={r["id"]:r for r in load_rules(ROOT/"rules")}
@pytest.mark.parametrize("rule_id,resource,expected",[
 ("broad-tenancy-policy",{"statements":["Allow group X to manage all-resources in tenancy"]},True),
 ("broad-tenancy-policy",{"statements":["Allow group X to read buckets in compartment Y"]},False),
 ("dynamic-group-missing-tag-condition",{"matching_rule":"Any {tag.ns.key.value = 'x'}"},False),
 ("dynamic-group-missing-tag-condition",{"matching_rule":"Any {instance.compartment.id = 'x'}"},True),
 ("secret-without-rotation",{"rotation_config":None},True),
 ("secret-without-rotation",{"rotation_config":{"rotation_interval":90,"is_scheduled_rotation_enabled":True}},False),
 ("secret-without-rotation",{"rotation_config":{"rotation_interval":90,"is_scheduled_rotation_enabled":False}},True),
 ("public-container-repository",{"is_public":True},True),
 ("public-container-repository",{"is_public":False},False),
])
def test_rule(rule_id,resource,expected):
 assert bool(scan({RULES[rule_id]["resource"]:[resource]},[RULES[rule_id]])) is expected

def test_fixture_reports_each_finding():
 data=json.loads((ROOT/"fixtures/oci.json").read_text())
 assert {f["rule"] for f in scan(data["resources"],list(RULES.values()))}==set(RULES)
