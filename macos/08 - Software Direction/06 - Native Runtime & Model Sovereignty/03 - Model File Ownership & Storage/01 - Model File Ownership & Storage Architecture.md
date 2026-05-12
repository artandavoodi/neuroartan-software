---
type: Architecture
subtype: Model File Ownership & Storage

title: ICOS Model File Ownership & Storage Architecture
document_id: SW-ICOS-ARC-2026-0024

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
version: "2.2"

created_date: "2026-04-28"
last_updated: "2026-04-29"
last_reviewed: "2026-04-29"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Model File Ownership"
  - "Storage Layout"
  - "Model Indexing"
  - "Access & Security"
  - "Versioning & Integrity"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/03 - Model File Ownership & Storage/01 - Model File Ownership & Storage Architecture.md"

related:
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/01 - Native LLM Runtime/01 - Native LLM Runtime Directive.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/02 - Ollama Deprecation & Migration/01 - Ollama Deprecation & Migration Standard.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

tags:
  - "icos"
  - "model-storage"
  - "ownership"
  - "runtime"
  - "software-direction"
---

## PURPOSE

Define ICOS-owned storage for all model files, eliminating external directory control and enabling deterministic runtime access.

---

## CORE POSITION

Model files are owned by ICOS.

External directories are not authoritative.

Model storage must be strictly separated from execution (runtime inference) and coordination (Supabase or cloud services).

---

## ACTIVE STORAGE POSITION · 2026-04-29

The active ICOS local runtime model is now a GGUF runtime artifact.

The current embedded model path is:

```text
macos/01 - App/ICOS/ICOS/Runtime/Models/icos-base.gguf
```

This file is the current BF16 reference runtime model.

It must be preserved until optimized quantized runtime variants are validated.

The active optimization sequence is:

```text
icos-base.gguf              → BF16 reference runtime model
icos-base-q4_k_m.gguf       → first fast product baseline candidate
icos-base-q5_k_m.gguf       → higher-quality product baseline candidate
```

Quantization creates additional model variants. It must not overwrite or destroy the BF16 reference model unless deletion is explicitly approved after successful runtime validation.

---

## STORAGE LIFECYCLE RULE

Model storage must distinguish between:

- source model artifacts
- executable runtime artifacts
- optimized runtime variants
- archived or deprecated artifacts

Source artifacts such as `safetensors`, tokenizer files, and configuration files may be retained during development for conversion or recovery.

Executable runtime artifacts must be registered separately from source artifacts.

Optimized variants must be stored and registered as distinct model releases, not as replacements until approved.

Deletion of large source artifacts is allowed only after:

- executable GGUF model is verified
- optimized Q4/Q5 candidate is tested
- ICOS UI receives model output correctly
- model registry is updated
- storage cleanup is approved

---

## EMBEDDED PRODUCT STORAGE STANDARD

Production ICOS must not depend on external development paths.

The user must never be required to manually place model files.

Production model storage must support:

- bundled starter model
- managed model downloader
- verified local installation
- model variant registry
- storage cleanup from the UI
- local/cloud model switching
- rollback to previous model versions

The runtime must resolve models only through the ICOS registry and never through guessed absolute paths.

---

## STORAGE ROOT

All models must reside under an ICOS-controlled root, for example:

- `~/Neuroartan/models/`

No dependency on third-party folders.

Supabase or any cloud coordination layer must not be used as a primary storage root for executable models.

---

## DIRECTORY LAYOUT

Standard layout:

- `models/{provider}/{model_name}/{version}/`
  - `weights/`
  - `tokenizer/`
  - `config/`
  - `metadata.json`

Layout must be consistent across all models.

---

## FILE FORMAT STANDARD

Each model must include:

- standardized weight format (e.g., GGUF / safetensors)
- tokenizer files (vocab, merges, tokenizer.json)
- config files (model config, generation config)
- metadata.json (ICOS canonical schema)

For executable local inference, GGUF is the active runtime format.

For source/reference storage, Hugging Face source artifacts may remain present during development.

For product use, the selected runtime model must be a verified GGUF release registered in the ICOS model registry.

---

## OWNERSHIP RULE

ICOS must:

- create and manage directories
- control read/write access
- register models internally

---

## MODEL INDEX

Maintain a registry with:

- model_id
- provider
- version
- path
- capabilities
- status (active/archived)
- format (source / runtime / quantized-runtime)
- quantization_level (BF16 / Q4_K_M / Q5_K_M / other)
- runtime_backend (llama.cpp / cloud / future-native)
- default_runtime_candidate (true / false)

  - execution_layer (local / cloud)
  - distribution_source (download / imported / trained)

Index is the source for runtime resolution.

---

## REGISTRY BINDING

The model index must:

- be the only authority for model resolution
- map model_id → absolute storage path
- enforce version isolation

Runtime must not bypass registry.

Registry must enforce separation between execution layer (inference), coordination layer (Supabase), and distribution layer (model delivery).

---

## ACCESS MODEL

Runtime must access models via:

- registry lookup → absolute path → load

No path guessing.

---

## LOADING CONTRACT

Model loading must follow:

- registry lookup
- integrity validation
- resource validation (RAM/VRAM)
- controlled load into runtime

No direct filesystem loading.

---

## VERSIONING

Each model must support:

- semantic versioning
- side-by-side versions
- safe rollback

---

## VERSION ISOLATION

Each version must:

- exist in separate directory
- never overwrite previous versions
- support safe parallel usage

---

## INTEGRITY

For each model:

- store checksums
- validate on load
- prevent corrupted execution

---

## SECURITY

Enforce:

- file permissions
- execution boundaries
- restricted write to protected models

---

## EXECUTION BOUNDARIES

Model execution must:

- operate within defined runtime limits
- prevent unauthorized file/system access
- enforce sandbox-like behavior

---

## MIGRATION RULE

During Ollama migration:

- copy artifacts into ICOS layout
- normalize structure
- register in model index

---

## RESOURCE AWARENESS

Store metadata for:

- RAM/VRAM requirements
- quantization level
- supported devices

The BF16 reference runtime model is not the product performance baseline.

Q4_K_M must be tested first as the fast baseline candidate.

Q5_K_M must be tested after Q4_K_M as the higher-quality baseline candidate.

Used by runtime scheduler.

---

## BACKUP & SNAPSHOT

Support:

- snapshots per version
- export/import bundles

---

## DISTRIBUTION FORMAT

Models must support export as:

- packaged archive (model + metadata)
- portable across environments

Import must reapply normalization pipeline.

---

## STORAGE CONSISTENCY GUARANTEE

System must guarantee:

- no duplicate model references
- no orphan model files
- registry and filesystem alignment

Consistency must be continuously validated.

---

## FAILURE CONDITION

Model paths depend on external tools or inconsistent layouts.

---

## SUCCESS CONDITION

All models are stored, indexed, and accessed under ICOS-controlled, deterministic structure.

---

## Change Log

- 2026-04-29 — v2.2 Documented GGUF runtime model storage position, BF16 reference preservation rule, Q4/Q5 quantized variant lifecycle, embedded product storage standard, runtime/source artifact distinction, and registry fields required for model variant governance. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-29. Execution Context: ICOS local inference runtime storage and quantization planning.
- 2026-04-29 — v2.1 Runtime–storage separation enforced. Storage architecture updated to explicitly separate execution layer, coordination layer (Supabase), and distribution layer. Supabase excluded from model storage root. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Vault Governance Agent (VGA). Agent ID: A-2026-0001. Execution Context: Model installation phase alignment.
- 2026-04-28 — v2.0 Storage architecture defined for full ICOS ownership, versioning, integrity, and registry-based access. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Model sovereignty layer.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.2

---

END OF DOCUMENT