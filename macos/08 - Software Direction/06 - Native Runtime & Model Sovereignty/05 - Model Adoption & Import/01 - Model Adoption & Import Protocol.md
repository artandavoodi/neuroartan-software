---
type: Protocol
subtype: Model Adoption & Import

title: ICOS Model Adoption & Import Protocol
document_id: SW-ICOS-PRT-2026-0026

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Native Runtime & Model Sovereignty"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"
  - "Legal Operations"

legal_sensitive: true
requires_gc_review: true
requires_creo_review: true
approval_status: Draft

gsa_protocol: "Pending Executive Validation"
gsa_approved: false

status: Active
lifecycle: Draft
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v1.6"
version: "2.0"

created_date: "2026-04-28"
last_updated: "2026-04-28"
last_reviewed: "2026-04-28"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Model Adoption"
  - "Model Import Pipeline"
  - "Model Normalization"
  - "Verification & Registration"
  - "Security & Licensing"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/05 - Model Adoption & Import/01 - Model Adoption & Import Protocol.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

 tags:
  - "icos"
  - "model"
  - "import"
  - "adoption"
  - "runtime"
  - "software-direction"
---

## PURPOSE

Define how external or local LLM models are adopted, imported, normalized, verified, and registered into ICOS under full system control.

---

## CORE POSITION

Models are adopted, not assumed.

Every model must pass through a controlled pipeline before execution.

---

## ADOPTION ENTRY POINTS

Models may originate from:

- local files (e.g., downloaded weights)
- external repositories (e.g., Hugging Face)
- transferred environments (e.g., Ollama migration)

All sources must converge into one pipeline.

---

## IMPORT PIPELINE

Every model must pass sequentially through:

1. intake
2. validation
3. normalization
4. storage
5. registration
6. verification

No stage may be skipped.

---

## INTAKE

System must capture:

- source location
- model format
- provider identity
- version
- license

---

## SOURCE PROVENANCE

Each input must include:

- origin identifier
- acquisition method
- timestamp
- ownership proof (if applicable)

Provenance must be preserved through the pipeline.

---

---

## VALIDATION

Before import:

- verify file integrity (checksums)
- verify compatibility with runtime
- verify licensing constraints

Invalid models must be rejected.

---

## COMPATIBILITY MATRIX

System must evaluate:

- supported architectures (e.g., transformer variants)
- supported formats (GGUF / safetensors)
- tokenizer compatibility

Incompatible models must be rejected or queued for conversion.

---

---

## NORMALIZATION

Convert model into ICOS canonical structure:

- reorganize files into standard layout
- align tokenizer/config formats
- generate metadata.json

No raw external structure retained.

---

## SCHEMA ENFORCEMENT

Normalization must enforce:

- canonical directory layout
- canonical metadata schema
- consistent file naming

Non-compliant artifacts must be corrected or rejected.

---

---

## STORAGE

Store model under ICOS-controlled directory:

- assign canonical path
- isolate by provider/model/version

Storage must match the Model Storage Architecture.

---

## STORAGE ATOMICITY

Model write operations must be:

- atomic (no partial states)
- verified post-write
- rolled back on failure

---

---

## REGISTRATION

Register model in Model Index with:

- model_id
- provider
- version
- capabilities
- resource requirements
- status

Registration enables runtime access.

---

## REGISTRATION GUARANTEES

Registration must ensure:

- unique model_id
- path validity
- version isolation

Duplicate or conflicting registrations are prohibited.

---

---

## VERIFICATION

After registration:

- run test inference
- validate output consistency
- benchmark basic performance

Model must be marked:

- verified
- unverified
- restricted

---

## VERIFICATION SUITE

Verification must include:

- deterministic test prompts
- output consistency checks
- basic latency measurement

Results must be stored with the model record.

---

---

## SECURITY

Ensure:

- no malicious payloads
- controlled file permissions
- isolation from system-critical components

---

## SANDBOX VALIDATION

Imported models must be tested in a sandboxed environment before activation.

---

---

## LICENSING

System must track:

- license type
- usage restrictions
- redistribution rights

Non-compliant models must be restricted.

---

## VERSION CONTROL

Support:

- multiple versions per model
- safe upgrades
- rollback capability

---

## UPGRADE STRATEGY

Upgrades must:

- create a new version
- run full pipeline
- not affect active version until verified

---

---

## UPDATE PIPELINE

Model updates must:

- follow same pipeline
- not overwrite active versions without validation

---

## DEPRECATION

Models may be:

- archived
- deprecated
- disabled

But never silently removed.

---

## AGENT INTEGRATION

Agents must:

- use only registered models
- never access raw/unverified models

---

## AGENT ACCESS CONTRACT

Agents must access models only via:

- model registry
- API gateway

Direct filesystem access is prohibited.

---

---

## NO DIRECT EXECUTION RULE

Imported models must not be executed before:

- normalization
- registration
- verification

---

## PIPELINE TRACEABILITY

Each import must produce a trace record including:

- stages completed
- validation results
- verification metrics

Trace must be auditable.

---

## FAILURE CONDITION

Models are executed without validation or stored in uncontrolled structure.

---

## SUCCESS CONDITION

All models are imported through a deterministic pipeline and become fully governed ICOS assets.

---

## Change Log

- 2026-04-28 — v2.0 Model adoption and import protocol defined to enforce deterministic pipeline, normalization, verification, and full system control. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Runtime sovereignty expansion.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.0

---

END OF DOCUMENT