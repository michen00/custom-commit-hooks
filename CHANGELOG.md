<!-- markdownlint-configure-file { "no-duplicate-heading": false } -->

# Changelog

All notable changes will be documented in this file. See [conventional commits](https://www.conventionalcommits.org) for commit guidelines.

The format is based on [Keep a Changelog](https://keepachangelog.com) and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

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

## [0.0.0](https://github.com/michen00/custom-commit-hooks/commits/v0.0.0) - 2025-12-06

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

<!-- generated by git-cliff -->
