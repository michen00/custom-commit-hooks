<!-- markdownlint-configure-file { "no-duplicate-heading": false } -->

# Changelog

All notable changes will be documented in this file. See [conventional commits](https://www.conventionalcommits.org) for commit guidelines.

The format is based on [Keep a Changelog](https://keepachangelog.com) and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

### 💚 Continuous Integration

- standardize bot auto-merge (#63) - ([587ed7e](https://github.com/michen00/custom-commit-hooks/commit/587ed7e11de5cfed71b0f517bb5e8f24f2e3e1c9)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- pin the Python version for pip caching (#64) - ([6c9ae7c](https://github.com/michen00/custom-commit-hooks/commit/6c9ae7cd13390603487bc2092afc6a30493a3717)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)

### 👷 Build

- **(deps)** bump actions/cache from 5 to 6 in the actions group (#65) - ([7f16bf3](https://github.com/michen00/custom-commit-hooks/commit/7f16bf31c6a4b9bc162087e51675c346753959df)) - [dependabot[bot]](mailto:49699333+dependabot[bot]@users.noreply.github.com)

### ⚙️ Miscellaneous Tasks

- correct what this repository tracks (#66) - ([7312def](https://github.com/michen00/custom-commit-hooks/commit/7312def49422b1e049e0bf700248bb8e26175ef4)) - [Michael I Chen](mailto:michen00.github@gmail.com)

## [0.0.4](https://github.com/michen00/custom-commit-hooks/compare/v0.0.3..v0.0.4) - 2026-01-14

### ✨ Features

- **(enhance-scope)** support breaking changes - ([5905a08](https://github.com/michen00/custom-commit-hooks/commit/5905a087f174bd7e50fff7d1d05b360405ad5826)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 👷 Build

- update pre-commit hooks (#14) - ([bb6bdd2](https://github.com/michen00/custom-commit-hooks/commit/bb6bdd28a2d21093c37ccc8c893329daa64415a5)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)

## [0.0.3](https://github.com/michen00/custom-commit-hooks/compare/v0.0.2..v0.0.3) - 2026-01-10

### 🐛 Fixes

- **(tests)** set default branch to main - ([fd54af9](https://github.com/michen00/custom-commit-hooks/commit/fd54af9e1c6e9399b60dabee28d4a3b665f495cd)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🧪 Testing

- **(tests)** add integration testing - ([01342db](https://github.com/michen00/custom-commit-hooks/commit/01342db65d024f27c4989045c6cb3a22a296048e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add coverage for auto-detect and edge cases - ([0c9b733](https://github.com/michen00/custom-commit-hooks/commit/0c9b73315aa678083b90c1f929c921a214588013)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ♻️ Refactor

- streamline commit source detection logic - ([70887dc](https://github.com/michen00/custom-commit-hooks/commit/70887dc695ff4dcdc518df15533acc733d8ff487)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

## [0.0.2](https://github.com/michen00/custom-commit-hooks/compare/v0.0.1..v0.0.2) - 2026-01-10

### ✨ Features

- **(conventional-merge-commit)** handle edge cases - ([28dee41](https://github.com/michen00/custom-commit-hooks/commit/28dee4160bf519510d539432a9d754e20e4fc5ea)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(hook)** support Merge/Squash variants - ([e7065a8](https://github.com/michen00/custom-commit-hooks/commit/e7065a8fa65e1d5981b181704b4e07189779920e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** add executable documentation tests - ([06b5276](https://github.com/michen00/custom-commit-hooks/commit/06b52760bf446d8cf77fc3fdfc7abbf38e9d73dc)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- simplify pattern matching - ([226b3de](https://github.com/michen00/custom-commit-hooks/commit/226b3de66d7ea0b69ed06649ac0c346ab1950cdb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🐛 Fixes

- **(hook)** handle squash commit source - ([a6e5bcf](https://github.com/michen00/custom-commit-hooks/commit/a6e5bcf12c29d4fb5b65ce6aad6ea8a7dd578a26)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** add a fallback for wait -n - ([602673d](https://github.com/michen00/custom-commit-hooks/commit/602673de92b30243b8494c94376bfb759b743727)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** verify body in test_enhance_scope - ([02cc263](https://github.com/michen00/custom-commit-hooks/commit/02cc2634f1725d7679d7bc4e630aa104eb37d434)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix boilerplate - ([f6d7646](https://github.com/michen00/custom-commit-hooks/commit/f6d76468182ff4a0943d864c4e9beb9ea7b466ea)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🧪 Testing

- **(hook)** add 720 CSV cases with parallel runner - ([5d69e68](https://github.com/michen00/custom-commit-hooks/commit/5d69e68df3f26c34ba438854f91d23bf1cac8d21)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- use terser test data - ([8b0b999](https://github.com/michen00/custom-commit-hooks/commit/8b0b99926b062707cf06fa60789f59342b6b608f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- simplify test case values - ([e10721d](https://github.com/michen00/custom-commit-hooks/commit/e10721dde3c805d707aec0b1958ca4b1a5e1b0d1)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 💚 Continuous Integration

- **(.github/workflows/CI.yml)** skip setup-python - ([ee9b0a1](https://github.com/michen00/custom-commit-hooks/commit/ee9b0a17816116e4174fefc67b91e077b6539e1f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- simplify greeting logic - ([9c9868a](https://github.com/michen00/custom-commit-hooks/commit/9c9868a6b623042852a30f33c6f61c23a5c8c68d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 📝 Documentation

- update a comment - ([4463dd7](https://github.com/michen00/custom-commit-hooks/commit/4463dd741a1daf1454a9b98d028161acdf5bb123)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ♻️ Refactor

- **(tests)** update body preservation tests - ([f31466f](https://github.com/michen00/custom-commit-hooks/commit/f31466fb1892258b75f143cc83742d8c1161430e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** extract merge-commit test helper - ([181765d](https://github.com/michen00/custom-commit-hooks/commit/181765da5c33c51b8871dbca52c16dcadfd8d3fa)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** extract enhance-scope helper - ([6c6f058](https://github.com/michen00/custom-commit-hooks/commit/6c6f058b28f88c653bb8ddef73c7711bb8b903c6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** simplify colors.sh, rename vars - ([1245ac1](https://github.com/michen00/custom-commit-hooks/commit/1245ac1162b46af1bec8106ed7032ffda8d29b8b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🎨 Styling

- add trailing newline - ([b0313ca](https://github.com/michen00/custom-commit-hooks/commit/b0313ca1636751b759b04fbc2ebd2ad81572a50e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚙️ Miscellaneous Tasks

- **(.gitlint)** update RegEx - ([40dca3f](https://github.com/michen00/custom-commit-hooks/commit/40dca3f19adee9d15ffec751bf54e4dc1d89ec32)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.gitlint)** prefer defaults - ([08059a0](https://github.com/michen00/custom-commit-hooks/commit/08059a0ada6eef155e25ee4953f3606fe005b852)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.gitlint)** update to include squash commits - ([54b1bb1](https://github.com/michen00/custom-commit-hooks/commit/54b1bb1001f6e0f12730529a4f98f388dcacfa43)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.gitlint)** enable ignoring squash commits - ([96f0401](https://github.com/michen00/custom-commit-hooks/commit/96f0401d9e3897b467ba686bcc0582db1fc6ba9b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.gitlint)** ignore merge commits in gitlint - ([4f28690](https://github.com/michen00/custom-commit-hooks/commit/4f286901ba422546b100030a4be62dc43cb3f4eb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** refactor job cleanup logic - ([8e1d8d8](https://github.com/michen00/custom-commit-hooks/commit/8e1d8d8518b7f9156239470138ef0e9c9e4c0195)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** improve cleanup handling - ([4fa4c79](https://github.com/michen00/custom-commit-hooks/commit/4fa4c7945d543304cfedf75e4b270e92fa2b890f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- enhance a comment - ([d6043ee](https://github.com/michen00/custom-commit-hooks/commit/d6043ee908cc22d7d818c2843236ff1df13ccfa2)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- enhance comment for merge pattern matching - ([5d9d4cd](https://github.com/michen00/custom-commit-hooks/commit/5d9d4cd7939b50bd759af5d8e2d7cab51e32f88f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add a comment - ([452b052](https://github.com/michen00/custom-commit-hooks/commit/452b052519c086dd0182e34ce946149f226f7d43)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- bump a hook version - ([92991e4](https://github.com/michen00/custom-commit-hooks/commit/92991e4fe9dbbe5f42b8d0b3b63d43a267c3a05c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- autoupdate pre-commit hooks (#9) - ([ae96b14](https://github.com/michen00/custom-commit-hooks/commit/ae96b14805109066a3b438b0acd5ec82836e841d)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)

## [0.0.1](https://github.com/michen00/custom-commit-hooks/compare/v0.0.0..v0.0.1) - 2025-12-24

### ✨ Features

- use colors consistently - ([7a8a863](https://github.com/michen00/custom-commit-hooks/commit/7a8a863bbe62f86a67f3645756968c2c7ec38939)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🐛 Fixes

- **(CLAUDE.md)** remove old pytest reference - ([eb1e516](https://github.com/michen00/custom-commit-hooks/commit/eb1e51653965e9af21eb200359ed60c478319dcd)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** fix verbosity - ([4fbf0d0](https://github.com/michen00/custom-commit-hooks/commit/4fbf0d0c088479ea098f79ebb76b95fcc5399d51)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(tests)** skip shellcheck for dynamic scripts - ([4589623](https://github.com/michen00/custom-commit-hooks/commit/4589623c3aad4e4929fb2e4f1dcbe241210ed7a5)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- properly initialize a variable - ([5733c36](https://github.com/michen00/custom-commit-hooks/commit/5733c36122565ff063724f2f5748f6558415353c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- implement suggestions - ([5077d8d](https://github.com/michen00/custom-commit-hooks/commit/5077d8d328713efb2e59c76b11e113723b6f1dd7)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- respect shebang - ([728746b](https://github.com/michen00/custom-commit-hooks/commit/728746b7081c4cfb898fa7ca7175616baeb0ed24)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- include omitted hooks - ([711df76](https://github.com/michen00/custom-commit-hooks/commit/711df760603104982c10262a3cbb61b359b01239)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- replace eval with bash -c - ([9efffe8](https://github.com/michen00/custom-commit-hooks/commit/9efffe830142ac3b7552a2a062fb829450a936d0)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix boilerplate - ([5fedffd](https://github.com/michen00/custom-commit-hooks/commit/5fedffd974619df7c21c97be0c228286bae0d297)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- correct merge commit message extraction logic - ([088e5cd](https://github.com/michen00/custom-commit-hooks/commit/088e5cdc494ac55b25e90cc67bed0f7b18881ab8)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚡ Performance

- **(conventional-merge-commit)** optimize - ([6766003](https://github.com/michen00/custom-commit-hooks/commit/6766003a4d833cbedcaa82830d67531a1b4f97c7)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- remove date from cache key - ([9151031](https://github.com/michen00/custom-commit-hooks/commit/9151031e18b25020f8859bb94f33ea8fe5825e2c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- don't cache pip since we don't use it - ([e0d84ff](https://github.com/michen00/custom-commit-hooks/commit/e0d84ffed4aea29d23532337f3ea3f5ed697addb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- improve pattern matching - ([85a7383](https://github.com/michen00/custom-commit-hooks/commit/85a73831092b7f3131a4004dec41386caf4e0384)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- get consistent on POSIX compliance - ([d3b8930](https://github.com/michen00/custom-commit-hooks/commit/d3b8930edb99a463e085dc32da930ad54bf64f85)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🧪 Testing

- add tests - ([569b561](https://github.com/michen00/custom-commit-hooks/commit/569b561cb47c55210c8e70f31f55522257f917e8)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 💚 Continuous Integration

- **(.github/workflows/CI.yml)** bump CACHE_NUMBER - ([3faedb5](https://github.com/michen00/custom-commit-hooks/commit/3faedb5251bea31339d28ea123b9a5c92e6a54d4)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- use pre-commit install-hooks for CI caching (#5) - ([685f25b](https://github.com/michen00/custom-commit-hooks/commit/685f25b241a71fc936b2bf16c3168b480c3399b9)) - [Copilot](mailto:198982749+Copilot@users.noreply.github.com)
- update CI - ([79aaca0](https://github.com/michen00/custom-commit-hooks/commit/79aaca048779489e4221e08368df06dbad60ef70)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add some actions - ([472c7a4](https://github.com/michen00/custom-commit-hooks/commit/472c7a4076502c4f564188e5408cd15abab6878a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add a workflow to greet new contributors - ([b957be4](https://github.com/michen00/custom-commit-hooks/commit/b957be436d2287b7a281d567c6a19919fdece822)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 👷 Build

- **(Makefile)** clarify stash messages - ([c42b12f](https://github.com/michen00/custom-commit-hooks/commit/c42b12f5d86cb014a9a60df0424c15d1eba446e5)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** improve develop target - ([8bedcbb](https://github.com/michen00/custom-commit-hooks/commit/8bedcbbdb95b57bac9951349997666f65c371e0c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** improve security - ([2786a00](https://github.com/michen00/custom-commit-hooks/commit/2786a000a3fdf2aa3323f8896bfc5c04e0047030)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(pre-commit)** add more hooks - ([494e01c](https://github.com/michen00/custom-commit-hooks/commit/494e01cbacf303f77938b7cfccbc0c2c7ef147a6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(pre-commit)** add shfmt hook - ([986b25e](https://github.com/michen00/custom-commit-hooks/commit/986b25e4a84440f3249cc03ff74747492e192848)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- cover hooks without file extension - ([d6cd023](https://github.com/michen00/custom-commit-hooks/commit/d6cd023c32b5d53e9863c67a0c45b3513b9b4e70)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update LFS configs - ([00cbf05](https://github.com/michen00/custom-commit-hooks/commit/00cbf05bc0c2adfdae53251a8e65139b03f1144a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- keep instructions updated - ([9d3f1a7](https://github.com/michen00/custom-commit-hooks/commit/9d3f1a7f4c5227eea4c67df763461dfc03c428b9)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update .gitignore - ([9570fea](https://github.com/michen00/custom-commit-hooks/commit/9570fea845d1047e6a9cab0549a843c216ef9d13)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add VSCode settings - ([fcdc02d](https://github.com/michen00/custom-commit-hooks/commit/fcdc02dd7be267ca88156725d3207d7353c6f8c6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add recommended extensions - ([a0b04c6](https://github.com/michen00/custom-commit-hooks/commit/a0b04c66a628cde7b5723e67966977a53686042a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 📝 Documentation

- **(AGENTS.md)** update commands - ([8711bf6](https://github.com/michen00/custom-commit-hooks/commit/8711bf68642634d1687d79df2f8d8949201be2ce)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CHANGELOG.md)** update CHANGELOG - ([046b6ce](https://github.com/michen00/custom-commit-hooks/commit/046b6ce7b4a7b34fbf55b2f712e46a52b3c466cb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CHANGELOG.md)** draft the changelog - ([5804487](https://github.com/michen00/custom-commit-hooks/commit/580448727faf1eb2b89477cb4c2bd59baa8c900f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CLAUDE.md)** update directory notes - ([22fca09](https://github.com/michen00/custom-commit-hooks/commit/22fca09996c57d1cfe072b77c1d791bb3600e61f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CONTRIBUTING.md)** update git cliff command - ([190879a](https://github.com/michen00/custom-commit-hooks/commit/190879ae0aa5ec61cd6e214c3ef98445bc5fed9b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CONTRIBUTING.md)** improve release guidance - ([b663acd](https://github.com/michen00/custom-commit-hooks/commit/b663acd11ac924136e29e397db38ae45c279771b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(README.md)** revise README - ([9724c2f](https://github.com/michen00/custom-commit-hooks/commit/9724c2f97f7e98a5413dbf43be38159d2e1aeb85)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(cliff.toml)** configure changelog - ([f5b5faa](https://github.com/michen00/custom-commit-hooks/commit/f5b5faac2e4a8fdab2981ae1aa6fa36385be77c1)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update project structure - ([2ae227e](https://github.com/michen00/custom-commit-hooks/commit/2ae227e3427dc4ffcfaecd699b0c57a13cdb851d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update descriptions - ([44f25d9](https://github.com/michen00/custom-commit-hooks/commit/44f25d9bfad37b4af18519bbcf59a4e1caae15ff)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add agentic help docs - ([bfa04cb](https://github.com/michen00/custom-commit-hooks/commit/bfa04cb61f1587b36fdc0e39ae52c462dba1013c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- enhance CONTRIBUTING.md - ([1f4df5c](https://github.com/michen00/custom-commit-hooks/commit/1f4df5cb2c02db40df77f39830b2956a62d7d245)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add CONTRIBUTING.md - ([b449e3e](https://github.com/michen00/custom-commit-hooks/commit/b449e3e5ad3779630621e3ba4761d09a4b283753)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- describe scripts with comments - ([7c734fb](https://github.com/michen00/custom-commit-hooks/commit/7c734fb625656f802fdd0550fdf3646a275a8301)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ♻️ Refactor

- use POSIX-compatible shell - ([8cda9c3](https://github.com/michen00/custom-commit-hooks/commit/8cda9c37d08dd4007a49b652aece2edbd6aea95b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- remove a redundant line - ([044bab0](https://github.com/michen00/custom-commit-hooks/commit/044bab0069b293dcd3c90f04df3b85b13346d6e7)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- use trap consistently - ([f65bf50](https://github.com/michen00/custom-commit-hooks/commit/f65bf50f077dfe04533fa6161b4d4af55ac77ccc)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- exit on error instead of warning - ([b5bc9dc](https://github.com/michen00/custom-commit-hooks/commit/b5bc9dc53aa3cfde1be96105c4b7353063d51638)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- prefer RETURN trap - ([75a06e3](https://github.com/michen00/custom-commit-hooks/commit/75a06e37daaa7e401e7e2d252142846219616449)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- clarify the fourth argument - ([4974df7](https://github.com/michen00/custom-commit-hooks/commit/4974df7335829dfb656317f2cc9cd1b3472cd7e9)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🎨 Styling

- **(tests/colors.sh)** sort colors - ([bab4030](https://github.com/michen00/custom-commit-hooks/commit/bab403076eb99fb7a33aa481a3b2b510afb342d7)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚙️ Miscellaneous Tasks

- **(CHANGELOG.md)** release v0.0.1 - ([aadbb02](https://github.com/michen00/custom-commit-hooks/commit/aadbb027e9ff8eedc91b0e3ab8ace19d1fc5b768)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CI)** un-bump CACHE_NUMBER - ([e846108](https://github.com/michen00/custom-commit-hooks/commit/e846108cd2a18cf52f3f02eda3da2c09b74fab46)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** match to updated boilerplate - ([13670a1](https://github.com/michen00/custom-commit-hooks/commit/13670a194e140a358bc7bfea15ce9cedea484bbe)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** remove unused - ([abfd320](https://github.com/michen00/custom-commit-hooks/commit/abfd320849551748bb12e8c97258da08229fbedd)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(Makefile)** remove obsolete boilerplate - ([672208d](https://github.com/michen00/custom-commit-hooks/commit/672208ddc0caa8e84c36642e20628b20e4104166)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(pre-commit)** update check-jsonschema version - ([a5a3b87](https://github.com/michen00/custom-commit-hooks/commit/a5a3b87dc2be9e7a9342017fac2496f21f8bfff4)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- improve portability of color codes - ([a91f3c2](https://github.com/michen00/custom-commit-hooks/commit/a91f3c2cae483de3e577c2ce031da838ebd9951e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- autofix via pre-commit hooks - ([6eec40e](https://github.com/michen00/custom-commit-hooks/commit/6eec40e19d659f74bab6c2c41c2cb41368ef1211)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- clarify instructions - ([61517eb](https://github.com/michen00/custom-commit-hooks/commit/61517eb7ed02eaaed2dee430dd619441d730e1c8)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- quote parameter expansion - ([68c78a1](https://github.com/michen00/custom-commit-hooks/commit/68c78a188c37f6af75369ff1422b1e0d0a8f697b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix trap logic - ([9e6d3d6](https://github.com/michen00/custom-commit-hooks/commit/9e6d3d65343d4a09624d93cb5e3da7c5a53f741b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update CI workflow and instructions - ([a76cb0e](https://github.com/michen00/custom-commit-hooks/commit/a76cb0e1c80e552ef09d3400057a22ceef3de8bf)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- remove conditional phrasing - ([7e108fa](https://github.com/michen00/custom-commit-hooks/commit/7e108faaf6e3f40efcd39e79332f79ade8589e19)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- apply suggestion from @Copilot - ([487c432](https://github.com/michen00/custom-commit-hooks/commit/487c432b02f72793d8c22daac6f77488e04b3381)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update shellcheck command for POSIX - ([4e4610d](https://github.com/michen00/custom-commit-hooks/commit/4e4610dd31d7abcfdf66ec5400b0dc18017f46ee)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add blank .git-blame-ignore-revs - ([4a754ba](https://github.com/michen00/custom-commit-hooks/commit/4a754ba7b9742e270ab2c22c6e0e6a9aa22403aa)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- drop yamlfmt - ([ffe6ca2](https://github.com/michen00/custom-commit-hooks/commit/ffe6ca23869d69b3ab72676c94ebba0c88b961e0)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- remove an invalid setting - ([e6acf1a](https://github.com/michen00/custom-commit-hooks/commit/e6acf1a53f0b6c183140898c1d2ad1563db99fae)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- remove an unused hook - ([0fb6909](https://github.com/michen00/custom-commit-hooks/commit/0fb6909bec3fd9d0e7479c7021a81befb1d905f2)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- autoupdate pre-commit hooks - ([09d2b5f](https://github.com/michen00/custom-commit-hooks/commit/09d2b5f5167a306aa70a58c29e0d903aa3edd4df)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)

## [0.0.0] - 2025-12-06

### ✨ Features

- include revert commits - ([ba146a0](https://github.com/michen00/custom-commit-hooks/commit/ba146a0b8127ca581f721e7ceaddfa453f15a27a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- draft conventional-merge-commit - ([4e9287f](https://github.com/michen00/custom-commit-hooks/commit/4e9287fa0ce36b39296a6dd540c0c5a836332563)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- draft enhance-scope - ([b36ab9d](https://github.com/michen00/custom-commit-hooks/commit/b36ab9db8cb54049d825189365db7403d22a07e6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- draft custom-prepare-commit-msg - ([9dd6261](https://github.com/michen00/custom-commit-hooks/commit/9dd62612a7b74ef0ba98b864fb55046ac94f5e8a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- draft custom-commit-msg - ([86e24cc](https://github.com/michen00/custom-commit-hooks/commit/86e24cc7e87b8c5d186a71a3563e7741f7e62895)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🐛 Fixes

- **(enhance-scope)** redirect to stderr - ([e329875](https://github.com/michen00/custom-commit-hooks/commit/e329875fea62656984a72de27ad42750b1af7f0e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(enhance-scope)** correct summary modification logic - ([e07be51](https://github.com/michen00/custom-commit-hooks/commit/e07be51ceb12b6ce4a71ed3aebaa949ce65095e5)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- handle empty string - ([3e8ea86](https://github.com/michen00/custom-commit-hooks/commit/3e8ea86e919fd5bce6b95b9ff59caabeff10f20f)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix placeholder script names - ([828ec9d](https://github.com/michen00/custom-commit-hooks/commit/828ec9d00d79c17db6b1e8f6dfbff82e3acf5058)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update hooks - ([ec171e7](https://github.com/michen00/custom-commit-hooks/commit/ec171e7f84704abefcf78d967556b0adca7b5659)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚡ Performance

- **(enhance-scope)** optimize - ([0615740](https://github.com/michen00/custom-commit-hooks/commit/0615740ff3498cc0763a77a0db9e3927df65fc53)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- optimize a hook - ([154a1cb](https://github.com/michen00/custom-commit-hooks/commit/154a1cb2dd0b768625aa7c2af64bc3427699a425)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 👷 Build

- use pre-commit - ([5257a2c](https://github.com/michen00/custom-commit-hooks/commit/5257a2c5423fe61d8ab25203dde1f6a7b2bef719)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 📝 Documentation

- **(README.md)** catch up to recent changes - ([1778ebb](https://github.com/michen00/custom-commit-hooks/commit/1778ebbddf1dcacf8a08cb27867c9959bde8c860)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- clarify README.md - ([827643d](https://github.com/michen00/custom-commit-hooks/commit/827643db7baef66c4aecaafc7c8da17769b0640a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🎨 Styling

- add config for gitlint - ([35adf62](https://github.com/michen00/custom-commit-hooks/commit/35adf628a4c1b350d3c264ee59ca96c95d3aea93)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚙️ Miscellaneous Tasks

- use script instead of unsupported_script - ([2b31136](https://github.com/michen00/custom-commit-hooks/commit/2b3113655dba30685fb887c913be74516cf4a762)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 💼 Other

- Improve README description for custom-prepare-commit-msg

Co-authored-by: michen00 <29467952+michen00@users.noreply.github.com> - ([dbd5556](https://github.com/michen00/custom-commit-hooks/commit/dbd5556309eaa9484a81b9e961b972837fc32e06)) - [copilot-swe-agent[bot]](mailto:198982749+Copilot@users.noreply.github.com)

- Add custom commit hooks for pre-commit

Co-authored-by: michen00 <29467952+michen00@users.noreply.github.com> - ([7416795](https://github.com/michen00/custom-commit-hooks/commit/74167953fa164d56b0c90b68337529c2e7d5cd6f)) - [copilot-swe-agent[bot]](mailto:198982749+Copilot@users.noreply.github.com)

- Initial commit - ([ff830d9](https://github.com/michen00/custom-commit-hooks/commit/ff830d937353b00cf107e8c02a228dd3b2db6ed5)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

<!-- generated by git-cliff -->
