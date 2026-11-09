# AI Language and Vision: secure triage pipelines (illustrative) — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Masking personal data in a piece of text with the Language service. This uses the PII entity detection call with a masking option, and it needs a Python environment with the OCI SDK configured for your tenancy.

import oci

config = oci.config.from_file()

language = oci.ai_language.AIServiceLanguageClient(config)

doc = oci.ai_language.models.TextDocument(

key="ticket-1042", text=ticket_text, language_code="en")

resp = language.batch_detect_language_pii_entities(

oci.ai_language.models.BatchDetectLanguagePiiEntitiesDetails(

documents=[doc], masking={"ALL": {"mode": "MASK"}}))

masked = resp.data.documents[0].masked_text   # store this, not ticket_text

Analyzing a scanned document in Object Storage with Vision. The result is text you can pass to the masking step above.

vision = oci.ai_vision.AIServiceVisionClient(config)

result = vision.analyze_document(

oci.ai_vision.models.AnalyzeDocumentDetails(

compartment_id=compartment_ocid,

document=oci.ai_vision.models.ObjectStorageDocumentDetails(

source="OBJECT_STORAGE",

namespace_name=namespace,

bucket_name=input_bucket,

object_name="scan-0007.pdf"),

features=[oci.ai_vision.models.DocumentTextDetectionFeature(

feature_type="TEXT_DETECTION")]))

print(result.headers.get("opc-request-id"))   # keep for the audit trail

For larger volumes, create a document job through the CLI or SDK with input and output locations in Object Storage, then poll for completion. Run the workload as an instance or resource principal and grant it only the Language, Vision and bucket access it needs.
