<!-- markdownlint-configure-file { "no-duplicate-heading": false } -->

# Changelog

All notable changes will be documented in this file. See [conventional commits](https://www.conventionalcommits.org) for commit guidelines.

The format is based on [Keep a Changelog](https://keepachangelog.com) and this project adheres to [Semantic Versioning](https://semver.org).

## [0.1.1](https://github.com/michen00/custom-commit-hooks/compare/v0.1.0..v0.1.1) - 2026-08-08

### 🐛 Fixes

- **(release)** stamp the version into the changelog (#69) - ([03c6133](https://github.com/michen00/custom-commit-hooks/commit/03c61338bb61a3f2262018701ae870528e02a3c6)) - [Michael I Chen](mailto:michen00.github@gmail.com)

### 💚 Continuous Integration

- make actionlint workflow dispatch-only (#71) - ([6936c0e](https://github.com/michen00/custom-commit-hooks/commit/6936c0e9c710e0bc164db03df590c6cb6b089dbc)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- standardize bot auto-merge (#63) - ([587ed7e](https://github.com/michen00/custom-commit-hooks/commit/587ed7e11de5cfed71b0f517bb5e8f24f2e3e1c9)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- pin the Python version for pip caching (#64) - ([6c9ae7c](https://github.com/michen00/custom-commit-hooks/commit/6c9ae7cd13390603487bc2092afc6a30493a3717)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)

### 👷 Build

- **(deps)** bump actions/cache from 5 to 6 in the actions group (#65) - ([7f16bf3](https://github.com/michen00/custom-commit-hooks/commit/7f16bf31c6a4b9bc162087e51675c346753959df)) - [dependabot[bot]](mailto:49699333+dependabot[bot]@users.noreply.github.com)

### ⚙️ Miscellaneous Tasks

- **(.gitignore)** regenerate from upstream (#68) - ([e4fe9d2](https://github.com/michen00/custom-commit-hooks/commit/e4fe9d23d0775469253d7f52a5c773eedc1313ed)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- correct what this repository tracks (#66) - ([7312def](https://github.com/michen00/custom-commit-hooks/commit/7312def49422b1e049e0bf700248bb8e26175ef4)) - [Michael I Chen](mailto:michen00.github@gmail.com)

## [0.1.0](https://github.com/michen00/custom-commit-hooks/compare/v0.0.4..v0.1.0) - 2026-08-05

### ✨ Features

- **(Makefile)** add release PR and watch commands - ([491c179](https://github.com/michen00/custom-commit-hooks/commit/491c17949efb20d77a0acab3db06cafdbb2e0cdc)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(conventional-merge-commits)** support revert - ([5b7e150](https://github.com/michen00/custom-commit-hooks/commit/5b7e150fb1d7b6f36a2155cff780bd6c7869cb1c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update boilerplate - ([f8aeda3](https://github.com/michen00/custom-commit-hooks/commit/f8aeda3c0da14c386c3eba5fe4c55692a1c7ce35)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🐛 Fixes

- **(cliff.toml)** skip release prep commits (#59) - ([3b4482c](https://github.com/michen00/custom-commit-hooks/commit/3b4482c669ddf94906d92e1d7700e5e8966eb110)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- rewrite the changelog atomically - ([878fa9f](https://github.com/michen00/custom-commit-hooks/commit/878fa9fb1590bbd2acc738f62701f9e7100e2461)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- keep the changelog footer without releases - ([3c7770c](https://github.com/michen00/custom-commit-hooks/commit/3c7770c16ef676a5702308cbb31b066154979232)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- make changelog regeneration idempotent - ([012f0fa](https://github.com/michen00/custom-commit-hooks/commit/012f0fa11762e97e4efbc9ba23b6a1d7a250a0fd)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- read pre-commit merge source env - ([0bc1af6](https://github.com/michen00/custom-commit-hooks/commit/0bc1af6fced527b7036ce4684220e3b82e860a41)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- restore short-circuit - ([11a3c95](https://github.com/michen00/custom-commit-hooks/commit/11a3c9528b1fe6fb308f99da8666e0c6516ad564)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚡ Performance

- check frequent patterns first - ([77f9913](https://github.com/michen00/custom-commit-hooks/commit/77f9913855bf12b385ee8455106f53c3807d4962)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- streamline pattern matching - ([d8c9c24](https://github.com/michen00/custom-commit-hooks/commit/d8c9c2495c807dd21990d017196bab33d52c625b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- streamlint a script - ([c138d2d](https://github.com/michen00/custom-commit-hooks/commit/c138d2db80352d760f00e65d3431dc360fa27dde)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🧪 Testing

- **(tests/test-integration.sh)** reduce flakiness - ([669eb9a](https://github.com/michen00/custom-commit-hooks/commit/669eb9ab351db4979162cf552aa4846bf48daa2c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- test cross-platform with coverage on ubuntu (#17) - ([d2f0d05](https://github.com/michen00/custom-commit-hooks/commit/d2f0d055ef502beda7a073023ff974b0e2e51f80)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)

### 💚 Continuous Integration

- **(.github/workflows/CI.yml)** fix coverage - ([5440ce8](https://github.com/michen00/custom-commit-hooks/commit/5440ce8c432785dc9e453286b784c6c17db2005d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.github/workflows/CI.yml)** update matrix - ([6259737](https://github.com/michen00/custom-commit-hooks/commit/6259737b130fae755e16ae1301ad4f6325aa66bf)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- bump the README rev pin on release (#61) - ([68ea779](https://github.com/michen00/custom-commit-hooks/commit/68ea77939796649ae1a7f982616742c5060c662c)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- gate releases on a protected environment (#58) - ([304e532](https://github.com/michen00/custom-commit-hooks/commit/304e532c34ef4f487156f9a66973f5985da90d7e)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- verify a reused tag is signed - ([f7e4301](https://github.com/michen00/custom-commit-hooks/commit/f7e4301e64b4b4963ab8cae82ba309c1134c2b61)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- verify an existing tag before publishing - ([ec58233](https://github.com/michen00/custom-commit-hooks/commit/ec58233761bf185521a01422d3e6a8013f2e9ccb)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- restrict release tagging to main merges - ([ef20365](https://github.com/michen00/custom-commit-hooks/commit/ef20365f89f62215621fbc1466427801be921706)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- validate versions via shared parser - ([51ca773](https://github.com/michen00/custom-commit-hooks/commit/51ca77363a6ec8e2b193347ca1b29f1de04f3154)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- reject malformed release versions strictly - ([4664237](https://github.com/michen00/custom-commit-hooks/commit/4664237dc657b87889973af974b1b1bb47249f09)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- auto-tag and publish on release merge - ([a0784f1](https://github.com/michen00/custom-commit-hooks/commit/a0784f16b1ecccd3711ea14d8ea3f1b7a58afa5d)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- infer release version from commits - ([dbe0dfc](https://github.com/michen00/custom-commit-hooks/commit/dbe0dfcb83d07dfb50b1a1bdc2fcd0d62f54f0b5)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- add prettier formatting step for CHANGELOG.md - ([ca14a28](https://github.com/michen00/custom-commit-hooks/commit/ca14a28d9568bbd297427fee87103502d7437add)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add signed release workflows - ([d4d90e2](https://github.com/michen00/custom-commit-hooks/commit/d4d90e23f1fe37629f210ec7a764e03d33a0864e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fold to lowercase - ([923d99c](https://github.com/michen00/custom-commit-hooks/commit/923d99c68269b16e361b5c147f4cc5a4e565f12b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix and improve coverage (#27) - ([e08b366](https://github.com/michen00/custom-commit-hooks/commit/e08b36695b3c47f440c6855de0b9a43ec2baeac0)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- use xmllint to convert coverage report to xml - ([d8e9c4c](https://github.com/michen00/custom-commit-hooks/commit/d8e9c4cd950b75e7fde0992d4ddb1d26ab0f8f84)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- improve reuse - ([b427dfc](https://github.com/michen00/custom-commit-hooks/commit/b427dfc2f4a00125536a2a62c98b9646108dc681)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fix a return value - ([750fd65](https://github.com/michen00/custom-commit-hooks/commit/750fd65c905c8f402b8ab4a3cff532b7e6c239eb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- return true - ([4a86d5b](https://github.com/michen00/custom-commit-hooks/commit/4a86d5b2d13a5e439dc8e3b799d4b5dd3bd7a14d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add concurrency settings - ([111635e](https://github.com/michen00/custom-commit-hooks/commit/111635eef10050307fdadbad5e68206a7a902b38)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- refactor multiline conditionals - ([d459f83](https://github.com/michen00/custom-commit-hooks/commit/d459f838a4a6a88b150646e6d5425a3f3744a6f5)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update maintenance flows (#25) - ([263f63d](https://github.com/michen00/custom-commit-hooks/commit/263f63d91fe6e136f54f233c5af6698f60b30788)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)
- refine triggers - ([ad968fa](https://github.com/michen00/custom-commit-hooks/commit/ad968fae710ed95ce297ffb6b46e16226df1e7d9)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- simplify conditionals - ([0c6a657](https://github.com/michen00/custom-commit-hooks/commit/0c6a6576b0cb710edb9ac02e68182da879943e18)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add signing - ([685d36f](https://github.com/michen00/custom-commit-hooks/commit/685d36f9cc77ceeae327048094824112c9d63ab6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- clean up old bot branches - ([f16d68f](https://github.com/michen00/custom-commit-hooks/commit/f16d68f2bb3dc35526a3ea6680c356bb90c52162)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add triggers - ([3f0a5a4](https://github.com/michen00/custom-commit-hooks/commit/3f0a5a47f6f9d632b90ab06759c8a96692f254f8)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update maintenance workflows - ([66a40cc](https://github.com/michen00/custom-commit-hooks/commit/66a40cc72d0db17584d9301ff1f97d936c656b7d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- fetch before switch - ([656b301](https://github.com/michen00/custom-commit-hooks/commit/656b3018098efe047035b3d835230a185fbc9335)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- configure concurrency settings - ([f97f8da](https://github.com/michen00/custom-commit-hooks/commit/f97f8da370a9f1ba33a32bbea6c60a83649fc4ed)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update ruby installation - ([1ab6c42](https://github.com/michen00/custom-commit-hooks/commit/1ab6c42641a73f37e921accb0e211b24074a5a20)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 👷 Build

- **(deps)** bump the actions group across 1 directory with 3 updates - ([0cd5060](https://github.com/michen00/custom-commit-hooks/commit/0cd50607870310e82a52c1c4d4103974c041705d)) - [dependabot[bot]](mailto:49699333+dependabot[bot]@users.noreply.github.com)
- **(deps)** bump the actions group with 2 updates - ([99d3388](https://github.com/michen00/custom-commit-hooks/commit/99d33884fcc9f77798407c8a3c528781d822e1e7)) - [dependabot[bot]](mailto:49699333+dependabot[bot]@users.noreply.github.com)
- add benchmark runner scripts - ([4100bc6](https://github.com/michen00/custom-commit-hooks/commit/4100bc66c3aa2c53c67c26b0a076140d3dc965c8)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 📝 Documentation

- **(.github/release.yml)** filter gemini bot - ([aecdafd](https://github.com/michen00/custom-commit-hooks/commit/aecdafd1a0a24198ad1eb9084c3c474ec00832df)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.github/release.yml)** exclude more bots - ([32da690](https://github.com/michen00/custom-commit-hooks/commit/32da69046300200121638dc597ea944cae636940)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.github/release.yml)** add release.yml - ([b1373c8](https://github.com/michen00/custom-commit-hooks/commit/b1373c895c95cbf117b69d4c65f4ab6c6b12f81d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(CHANGELOG.md)** backfill released versions - ([cd4b10a](https://github.com/michen00/custom-commit-hooks/commit/cd4b10ad5f1ce7929b6d944615ed61601132cc9f)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- **(README.md)** update badges - ([3fda222](https://github.com/michen00/custom-commit-hooks/commit/3fda222d46f6f78685ba6656be2f80f0456518c0)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(README.md)** add DeepWiki badge - ([51bb7b6](https://github.com/michen00/custom-commit-hooks/commit/51bb7b61a8d0643b1178d9881ed0bfaf3aa7d37b)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- use a portable key removal command - ([b887f7e](https://github.com/michen00/custom-commit-hooks/commit/b887f7e42c70537af7250c070bdb4a0f1a73c126)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- add release key setup instructions - ([296525b](https://github.com/michen00/custom-commit-hooks/commit/296525bced5a5e8b540405d01598cc9c15fc0e8b)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- add atomic commits cursor skill - ([da224ef](https://github.com/michen00/custom-commit-hooks/commit/da224ef36188d2e697ae1b61f56df1b111f9e29d)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- document release automation - ([231d733](https://github.com/michen00/custom-commit-hooks/commit/231d733b83d419b78022f50c0c201a30e7ff796e)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update issue templates - ([c162dba](https://github.com/michen00/custom-commit-hooks/commit/c162dbac824245859e77c9c6295a5b2076b7c4ed)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- add issue templates - ([ccbb35b](https://github.com/michen00/custom-commit-hooks/commit/ccbb35b58cfb1572575608ab4d91b72ec7d71ede)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- filter more bots - ([2ac8666](https://github.com/michen00/custom-commit-hooks/commit/2ac866693b145c2051aa3afee2385bafdea12b66)) - [Michael I Chen](mailto:michael.chen.0@gmail.com)

### ♻️ Refactor

- extract shared release version parser - ([23d932f](https://github.com/michen00/custom-commit-hooks/commit/23d932f613d9e27900023be079b11c55952ea4df)) - [Michael I Chen](mailto:michen00.github@gmail.com)
- simplify the patterns - ([39e52ee](https://github.com/michen00/custom-commit-hooks/commit/39e52ee8bc94d8e5f54b20f6afc9bbc632dfe1f0)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- enhance pattern matching - ([ee59b7d](https://github.com/michen00/custom-commit-hooks/commit/ee59b7db5e6d52ed556e5b45a56e2206941d48e6)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- accept simplicity - ([dd2187f](https://github.com/michen00/custom-commit-hooks/commit/dd2187f6ca86a82dd6c06c7db750ef3c75c8c402)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- simplify a composite action - ([98deefd](https://github.com/michen00/custom-commit-hooks/commit/98deefd84e0d2fdd81042c051881c9a4926c04a3)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### 🎨 Styling

- **(.github/dependabot.yml)** use fewer quotes - ([de2a4dc](https://github.com/michen00/custom-commit-hooks/commit/de2a4dc3cda7909ad49092c65c7689d6aaba923c)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(\_typos.toml)** prefer single quotes - ([cb60701](https://github.com/michen00/custom-commit-hooks/commit/cb607016a33a3b72cbcce6fcf949836fc855d681)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- don't overspecify defaults - ([957c544](https://github.com/michen00/custom-commit-hooks/commit/957c54486e24ec4c6e6810dbca6e5a0bfe17678a)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

### ⚙️ Miscellaneous Tasks

- **(.gitattributes)** fix Windows line endings - ([98848f4](https://github.com/michen00/custom-commit-hooks/commit/98848f48fa1d5674ace819f142f7172ab850eaf7)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(.yamllint)** remove an unused ignore - ([2a7aed2](https://github.com/michen00/custom-commit-hooks/commit/2a7aed227a74054e5fe4b8bd1add8af2f5f99ed0)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- **(\_typos.toml)** fix a pattern - ([ff41d83](https://github.com/michen00/custom-commit-hooks/commit/ff41d83750947cd2918aa6ef3ee8cb8f12037b44)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- autoupdate pre-commit hooks (#56) - ([a431446](https://github.com/michen00/custom-commit-hooks/commit/a4314467ba9b52480baf3f4003ac195dab8f9705)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#55) - ([3881f1f](https://github.com/michen00/custom-commit-hooks/commit/3881f1f2ce79fa2d104f3f96f6bebcbcc899f009)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#54) - ([623d6fd](https://github.com/michen00/custom-commit-hooks/commit/623d6fd88a3785a97e11a6fef86e0fa924390a13)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#53) - ([60f79ec](https://github.com/michen00/custom-commit-hooks/commit/60f79ec7e16fca212fff41ce42eeb3a77ff2f70f)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#52) - ([0615d6e](https://github.com/michen00/custom-commit-hooks/commit/0615d6ec3526bccb301a1f2db3fa520e23a662f4)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#51) - ([ad9cc37](https://github.com/michen00/custom-commit-hooks/commit/ad9cc3782ddb7cee6bd930d570d8a084c0c5d89b)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#50) - ([d1e0aa8](https://github.com/michen00/custom-commit-hooks/commit/d1e0aa8e12d52e4166ba31860e584c81fc82e85e)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#49) - ([6d75e53](https://github.com/michen00/custom-commit-hooks/commit/6d75e537d95ecfb32a22f7e49f90e7f41d297ad0)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#48) - ([dfae247](https://github.com/michen00/custom-commit-hooks/commit/dfae247a5c6f65ee694f2462d7efe42d9d0d0d3e)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#47) - ([7bbb877](https://github.com/michen00/custom-commit-hooks/commit/7bbb877e10b286840515836d4ae3ccfbdce0f699)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#46) - ([ffbd3b9](https://github.com/michen00/custom-commit-hooks/commit/ffbd3b966321d46f0db51033999d21274e006741)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#45) - ([9b99388](https://github.com/michen00/custom-commit-hooks/commit/9b993889f2ed839012e6f66795a342c37ab3bb92)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#44) - ([47b599a](https://github.com/michen00/custom-commit-hooks/commit/47b599ad46821ba428667704e8a7fa60eba407b5)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#43) - ([c1142cb](https://github.com/michen00/custom-commit-hooks/commit/c1142cb771f1b15cd2907954c424dc1dc97abb64)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#41) - ([9ada54a](https://github.com/michen00/custom-commit-hooks/commit/9ada54a4027b6d805cfefede7f27138d1a9d8ad6)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#40) - ([849f700](https://github.com/michen00/custom-commit-hooks/commit/849f700bcff2cc529eaacd363e0503462e28eb59)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#38) - ([f5fa614](https://github.com/michen00/custom-commit-hooks/commit/f5fa614f6ca4531cbf1c7c78eb51548d6e4273b2)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#37) - ([824161c](https://github.com/michen00/custom-commit-hooks/commit/824161c30671ad448250a6babb075915af5ab80b)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#36) - ([33fae67](https://github.com/michen00/custom-commit-hooks/commit/33fae67ce6276661b57d10e8a80b94ff445e2464)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#34) - ([c7e7fc2](https://github.com/michen00/custom-commit-hooks/commit/c7e7fc203132bc688c73c951ba155da15bf346eb)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#33) - ([7575e01](https://github.com/michen00/custom-commit-hooks/commit/7575e01c1baa8cffa75222d449ad3757e62baedd)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#32) - ([a620f62](https://github.com/michen00/custom-commit-hooks/commit/a620f629f5bd8f382267d75cffd6df07eb4b1aa1)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks (#31) - ([ab95952](https://github.com/michen00/custom-commit-hooks/commit/ab95952c09c24cb3dd2a57105fa8dcfe1a019e01)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autoupdate pre-commit hooks - ([0b52086](https://github.com/michen00/custom-commit-hooks/commit/0b52086fe0ea1852ca1c9f520db4793f191bcfbb)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- autofix via pre-commit hooks - ([54f683e](https://github.com/michen00/custom-commit-hooks/commit/54f683e217649c1733e020c8ce327041a90995bc)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- sync boilerplate - ([bd710e8](https://github.com/michen00/custom-commit-hooks/commit/bd710e88950318b6578ad576758a14223c01a801)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- update .gitattributes - ([b7274ff](https://github.com/michen00/custom-commit-hooks/commit/b7274ff6241bfe67734c728013a71c7b37ccc4fb)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- autoupdate pre-commit hooks (#16) - ([f8c083c](https://github.com/michen00/custom-commit-hooks/commit/f8c083c3e5fe23711da1d6938a575fabf219e051)) - [pre-commit-ci[bot]](mailto:66853113+pre-commit-ci[bot]@users.noreply.github.com)
- improve PR creation logic - ([3326407](https://github.com/michen00/custom-commit-hooks/commit/33264074176521ffe9f4f281b7184a00d2799c42)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)
- use v0.0.4 of self - ([7fdbf0d](https://github.com/michen00/custom-commit-hooks/commit/7fdbf0d2738f45ef1fa992c0c6f5abec78c3c381)) - [Michael I Chen](mailto:michael.chen@aicadium.ai)

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
