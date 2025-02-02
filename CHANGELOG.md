# Changelog

## [1.0.0](https://github.com/lpchaim/nixos/compare/v1.0.0...v1.0.0) (2025-01-05)


### Features

* Better pull workflow settings ([3dcc039](https://github.com/lpchaim/nixos/commit/3dcc039adf24fa01019b50a8604b9bd827a99f2d))
* Remove lix ([62ded98](https://github.com/lpchaim/nixos/commit/62ded98b9d3957ed920d5e3894927b261813647d))
* Tweak README.md ([7259e80](https://github.com/lpchaim/nixos/commit/7259e80ef3781b82dd8306fad1fe5a9c69d74bf0))


### Miscellaneous Chores

* Release 1.0.0 ([4c5c575](https://github.com/lpchaim/nixos/commit/4c5c5755146b6f74b7efba5fd2650fb15be67d03))

## [1.0.0](https://github.com/lpchaim/nixos/compare/v0.3.0...v1.0.0) (2025-01-03)


### Features

* Add basic declarative syncthing configuration ([23028dd](https://github.com/lpchaim/nixos/commit/23028dda6dba61feba13865944cdbf230c41a28e))
* Add kdeconnect ([fe7d5fc](https://github.com/lpchaim/nixos/commit/fe7d5fc106bf9a4dd2b97de8a0c87a42b605abc3))
* Add laptop + steamdeck to syncthing, misc improvements ([2a8b2f1](https://github.com/lpchaim/nixos/commit/2a8b2f110697c0f0410bb2c3c17a13a3fd7d2bbf))
* Add lix, fix ags inputs, misc fixes ([87a7a83](https://github.com/lpchaim/nixos/commit/87a7a83deb1904106f43f8976e6f8954d06458ba))
* Add Logseq ([e36b4a5](https://github.com/lpchaim/nixos/commit/e36b4a5717623f86c394202c43b1e9d62f42ce11))
* Add waypipe ([d491092](https://github.com/lpchaim/nixos/commit/d49109289a6d31140c01ac08f4b51c4b8f971d1b))
* Atuin daemon + login oneshot ([d7bcffa](https://github.com/lpchaim/nixos/commit/d7bcffa82ebb882cb20c5f3a7921dea325dc6071))
* Atuin tweaks ([e9a8d76](https://github.com/lpchaim/nixos/commit/e9a8d76c942d5e2f40240f8025c75d0a887c01f6))
* Better tailscale module ([ba9178e](https://github.com/lpchaim/nixos/commit/ba9178eceb0cd244d16c436cff5b0af87ede16ef))
* Better update flake CI workflow ([96eb61c](https://github.com/lpchaim/nixos/commit/96eb61cc8a70ec525d50e82739f6699db3805ee0))
* Cachyos kernel on desktops, small fixes ([cf7953c](https://github.com/lpchaim/nixos/commit/cf7953c3df5d975524d4fe747fcd339e473801ed))
* Change desktop kernel to xanmod ([9bd6dc0](https://github.com/lpchaim/nixos/commit/9bd6dc0a16a51095e17eddb082d28291a6ae444b))
* Check and fix NTFS filesystem before mounting ([6c0b25b](https://github.com/lpchaim/nixos/commit/6c0b25bd9126a37be6300a03443f99f834da0926))
* **cli:** Add progress cli program ([29b604f](https://github.com/lpchaim/nixos/commit/29b604fd9ab62ef32b065916d64fe284713ff79b))
* Gaming tweaks, better proton-ge handling ([18ff00c](https://github.com/lpchaim/nixos/commit/18ff00c6e8b3582fa0ae9f9f5e7cad77ed68bc13))
* Hyprland tweaks ([f62714f](https://github.com/lpchaim/nixos/commit/f62714f41e99e137c45b8afa7cfb6a59efe0ed1d))
* Nix settings tweaks ([f835d25](https://github.com/lpchaim/nixos/commit/f835d2539315447c1a31e9629b7c2d34efbb1c0f))
* **steamdeck:** Auto mount steam deck sd card ([947e879](https://github.com/lpchaim/nixos/commit/947e879ec6cf7a2c4b07cb444d38a25b6674043e))
* Tweak fish options, add done plugin ([dc8dee2](https://github.com/lpchaim/nixos/commit/dc8dee2e7c0e021aba027d1e26e2032d44224b02))
* U2F security changes ([0eac09e](https://github.com/lpchaim/nixos/commit/0eac09e7d3a87c01c34edae288306d0f3ac675ba))
* Weekly update + tailscale enhancements ([4e2cab0](https://github.com/lpchaim/nixos/commit/4e2cab0cb17faa95b7b638859a87af96b7d9ab83))


### Bug Fixes

* Add exec flag to desktop's NTFS mount ([4dd83b8](https://github.com/lpchaim/nixos/commit/4dd83b8b0afc30fbb40f4e0f9fba8eb2f8bf376c))
* Change atuin-daemon target to multi-user.target ([2591ae0](https://github.com/lpchaim/nixos/commit/2591ae09b8e262684b2b055d3f21412f596c3c2f))
* CI actions ([10d71f1](https://github.com/lpchaim/nixos/commit/10d71f17bbea8f674abf9dc7234597eb6017f1c8))
* Disable most gaming features except for steam on laptop ([aff7cb9](https://github.com/lpchaim/nixos/commit/aff7cb90c4c375110cdd6da7e380503a1cd40a05))
* Disable u2fAuth altogether for sshd service ([f1337f3](https://github.com/lpchaim/nixos/commit/f1337f328e310c6e4ee16642f8a407f3ccf9469e))
* Have syncthing-tray wait for graphical environment ([f2b2c62](https://github.com/lpchaim/nixos/commit/f2b2c62e026fd658bde185155bf36bb185edec36))
* **hyprland:** Don't resolve binds by symbol ([55843a4](https://github.com/lpchaim/nixos/commit/55843a42ce337e494e4da1ca5490c2a5c8f28b44))
* Misc fixes and refactoring ([0fe25f2](https://github.com/lpchaim/nixos/commit/0fe25f29f30005462c8190e225704a6a123fe7ca))
* Multiline strings in update flake action ([d851f3a](https://github.com/lpchaim/nixos/commit/d851f3ac42ff33a5b03834f5a8fc83fce383b8a5))
* Nushell fixes ([4b60ece](https://github.com/lpchaim/nixos/commit/4b60ece0d1261e2f5cf0d2184cfc387655e6e6ba))
* NVIDIA fixes ([5ef972d](https://github.com/lpchaim/nixos/commit/5ef972d02a0057693cca2b1e5e3e1e2aa274d7c7))
* Patch sshd PAM policy to relax login restrictions ([c1b186c](https://github.com/lpchaim/nixos/commit/c1b186c7e85d79eeb40bf98f978516f3ed5e1ea1))
* Pin aylur's dotfiles to the last freely available version ([8d57895](https://github.com/lpchaim/nixos/commit/8d57895a4ac4f10fd66a7b6c74ea00328dab7c44))
* Remove tee from update flake CI workflow ([b509255](https://github.com/lpchaim/nixos/commit/b509255417f720f80806b273a0db402cd8c274e4))
* Steam deck home top level config argument ([b4b4dda](https://github.com/lpchaim/nixos/commit/b4b4dda6b715e5eaf776b0cefe1b8a37b61028d3))
* Steam deck syncthing secrets formatting ([7c8ab69](https://github.com/lpchaim/nixos/commit/7c8ab6973034882e4f374e02ac3dbfb1b94cab18))
* **steandeck:** Disable extra steam tweaks on steam deck ([c984a18](https://github.com/lpchaim/nixos/commit/c984a18cfe63f6ecdfc2eac6b9fcb839f83eb5b4))
* tee --output-error missing actual argument ([48e92cd](https://github.com/lpchaim/nixos/commit/48e92cd00d209c412dd64ba1686dc94ae00f0104))
* Update flake inputs CI workflow pipe exit status ([9c9f1c1](https://github.com/lpchaim/nixos/commit/9c9f1c13fb516a3b1c28339a74b4050c7af95ce5))


### Miscellaneous Chores

* Release 1.0.0 ([d22abaa](https://github.com/lpchaim/nixos/commit/d22abaad4ba6905e14ccf856e6e84788536b8be4))

## [0.3.0](https://github.com/lpchaim/nixos/compare/v0.2.0...v0.3.0) (2024-10-04)


### Features

* Add Android udev rules, adb ([54471c8](https://github.com/lpchaim/nixos/commit/54471c8823b4728ec8b91dadc998d96fa5862756))
* Add atuin ([2033323](https://github.com/lpchaim/nixos/commit/2033323e4c00d65166dd903fe49ba1723b9d433f))
* Add basic stylix support to ags ([210a472](https://github.com/lpchaim/nixos/commit/210a472bcfa9e35028cd51ce0d35e507f2d2a9a3))
* Add build flake CI action ([22caa67](https://github.com/lpchaim/nixos/commit/22caa676829b94c21d398740f7eb0ef8cbe0d536))
* Add chaotic-cx input and substituter ([4922734](https://github.com/lpchaim/nixos/commit/4922734368df1ee7d9e96d8fd6c272ab14cce30a))
* Add fish support to hishtory ([b57ae0e](https://github.com/lpchaim/nixos/commit/b57ae0ef3d1378f8e41aa12ab01a14f4228ee316))
* Add flake-compat ([dcd44ee](https://github.com/lpchaim/nixos/commit/dcd44ee37d9f9897f9acb5ff035b59bff071a1e4))
* Add flake-schemas, omnix-cli ([9c86143](https://github.com/lpchaim/nixos/commit/9c861433f33cbf20bcf952f3d075f9031855682d))
* Add gamemode and gamescope to gaming trait ([8e6d80d](https://github.com/lpchaim/nixos/commit/8e6d80d1c0c03a53503614334650f4623fcb0fce))
* Add gaming and desktop traits to desktop config ([024cd21](https://github.com/lpchaim/nixos/commit/024cd21e6142f784bcc266718de464e21dc42f2d))
* Add generic nixos configuration ([8d69544](https://github.com/lpchaim/nixos/commit/8d695443ac82d2ef6f0395e5247be746c68ec8e8))
* Add get-ci-info app ([536d456](https://github.com/lpchaim/nixos/commit/536d4563c3c6645192fd724fcda967925cd12509))
* Add GitHub access token ([1ee07a5](https://github.com/lpchaim/nixos/commit/1ee07a5857dd40b9f838a076417f15ad28ad09f3))
* Add mangohud ([4491f49](https://github.com/lpchaim/nixos/commit/4491f49648639c4cf2a565d11a779f48d3c7055a))
* Add my binary cache ([cacc233](https://github.com/lpchaim/nixos/commit/cacc233683bb3c86d0ce24ee86de2edb75f521f3))
* Add nh, misc tweaks and fixes ([75c74dc](https://github.com/lpchaim/nixos/commit/75c74dc33e56b25457033526fcad3e04b9ce0ad4))
* Add nix-gaming ([6ed7319](https://github.com/lpchaim/nixos/commit/6ed731970c6347a87d5e4306247150553080f2c2))
* Add nixos-generators ([18af727](https://github.com/lpchaim/nixos/commit/18af727645e556b2540465ab6c85fd127644083b))
* Add nushell script writers ([66946df](https://github.com/lpchaim/nixos/commit/66946df66c29172aebf0ec415bde6892457c3cab))
* Add nushell scripts ([a9c3781](https://github.com/lpchaim/nixos/commit/a9c37814fdbb5d04ba6086fd87e241c813c3db43))
* Add OBS ([7759cc4](https://github.com/lpchaim/nixos/commit/7759cc4263e4b81a984ddcb5f2721dcc216612db))
* Add parsec ([fc9e87d](https://github.com/lpchaim/nixos/commit/fc9e87daec3b65a96ca8633f1effe769cad87c0e))
* Add pipewire and gamepad idle inhibitors to hyprland ([d788436](https://github.com/lpchaim/nixos/commit/d78843622931d5cd170bd8db5a183502cd1f1fd5))
* Add secondary disk mount to desktop config ([02a30db](https://github.com/lpchaim/nixos/commit/02a30db7642183fd7c77d92006daba67c65417d5))
* **ags:** Add aylur's dotfiles ([29d54b4](https://github.com/lpchaim/nixos/commit/29d54b40de3db6ef942d72aaf82004331c5d2bf7))
* Better Raspberry Pi 4 storage configuration ([0b73638](https://github.com/lpchaim/nixos/commit/0b73638b1ada98b0de85a6a4d3a3a09b6abd815d))
* Better update flake CI workflow ([81d2b16](https://github.com/lpchaim/nixos/commit/81d2b16498433a99931bf5b3d09533b283e48a77))
* Build raspberrypi host on GH actions ([fb648ef](https://github.com/lpchaim/nixos/commit/fb648ef9c688bfb5b99ccf96ae11f9ab593b9aef))
* Change base16 theme to stella ([7b97880](https://github.com/lpchaim/nixos/commit/7b97880bc044a430a61aae1ed577e936eb75a79f))
* CI enhancements ([446dbb4](https://github.com/lpchaim/nixos/commit/446dbb40ac5bab5b21220400f41e4bd8b325342c))
* Clean up justfile, add security tasks ([8d7a0ee](https://github.com/lpchaim/nixos/commit/8d7a0ee5e8e8b77a4923a1267ac50c45ea22544a))
* **cli:** Add chafa, hexyl and procs ([265fd09](https://github.com/lpchaim/nixos/commit/265fd090b7ff37ff47150ae44cf3820ad7d137b6))
* **cli:** Add fish plugins ([d53fbc4](https://github.com/lpchaim/nixos/commit/d53fbc46e442808943ece3ffb97e50fd0683b878))
* **cli:** Add fish shell module ([c27330f](https://github.com/lpchaim/nixos/commit/c27330fba67c9dc201c10674e346930c79c138f7))
* **cli:** Add fx ([7bbe1cc](https://github.com/lpchaim/nixos/commit/7bbe1cc01e270175b7e618a932bcf5b8ddcc37e1))
* **cli:** Add howdoi, tgpt and tig ([a9b6624](https://github.com/lpchaim/nixos/commit/a9b66244c017a084b6af922371727be28241a8a8))
* **cli:** Add inotify-tools ([8233dd3](https://github.com/lpchaim/nixos/commit/8233dd3d67945e5b383cc89b25a23a2fe1abe3ea))
* **cli:** Add nix-community/comma ([d5a0172](https://github.com/lpchaim/nixos/commit/d5a01721c618a31b386a63161e950fca794b2b0d))
* **cli:** Enable default shell by default ([f92a133](https://github.com/lpchaim/nixos/commit/f92a133ad62f528f468cf0e38c495ed138f20288))
* Create desktop trait ([38465c2](https://github.com/lpchaim/nixos/commit/38465c20cb79b4e9b1edbf3fc89bdf7f0055cb3f))
* Create pull.yml ([b06ee64](https://github.com/lpchaim/nixos/commit/b06ee6471ca3801cdbce5596e00ba4d7a61fd663))
* CUDA support on desktop, flake inputs update ([1049cf7](https://github.com/lpchaim/nixos/commit/1049cf7ab48fe06d4163df7318e9eddeef9b1094))
* Deploy devShell ([62e54da](https://github.com/lpchaim/nixos/commit/62e54dae2cf049f2453613bb48cc9c582327b9fc))
* Deployment shell enhancements, generic minimal home configs ([bc754f0](https://github.com/lpchaim/nixos/commit/bc754f092be29885311cf68c6b84bf6d202fe02f))
* Enable aarch64 binfmt emulation on x86 systems by default ([b2637ba](https://github.com/lpchaim/nixos/commit/b2637ba2ead60a529ea60fd61355324e74caeb34))
* Enable secure boot on desktop ([19dfd65](https://github.com/lpchaim/nixos/commit/19dfd653dc1fa5cc590a0c90cde90490b6c49c6a))
* **gui:** Add brave browser ([5532c0d](https://github.com/lpchaim/nixos/commit/5532c0d3f751f35c54e997d463784e8e1eca7def))
* **helix:** Force built-in catppuccin theme ([81cfb16](https://github.com/lpchaim/nixos/commit/81cfb162b296abd93e71e991d24d814b6add5759))
* **home:** Enable garbage collection by default ([dd6a492](https://github.com/lpchaim/nixos/commit/dd6a4920ed51dc8a54a5c6e2352dce2c311566f1))
* **hyprland:** Add keyboard layout switching with alt + space ([9981079](https://github.com/lpchaim/nixos/commit/9981079f2384e52805f4d4a9e83782045919cc9b))
* **hyprland:** Add SwayOSD ([c684e07](https://github.com/lpchaim/nixos/commit/c684e079e1bc6522359772fa05e0159faaf7c66e))
* Initial Desktop config ([8476548](https://github.com/lpchaim/nixos/commit/847654814e3e6a5339b6a04f913857e589f71cac))
* Initial Raspberry Pi 4 configuration ([5dd1b3b](https://github.com/lpchaim/nixos/commit/5dd1b3b6992bc8fc276d3dcd902d27fe16732e29))
* Initial secure boot support ([46283d2](https://github.com/lpchaim/nixos/commit/46283d203c421cfab7fc4e19047641a352d40ae4))
* Initial security key support ([b74ad61](https://github.com/lpchaim/nixos/commit/b74ad61b0ffe1a38f1e4076bb0062913e1b3af64))
* Initial steam deck config ([764c674](https://github.com/lpchaim/nixos/commit/764c6740be50c06aa19bb50cd125a8f6f7927e39))
* **just:** Initial just implementation ([73d0a39](https://github.com/lpchaim/nixos/commit/73d0a39144dece83e425add63c789b800eb8ccb7))
* **just:** Justfile improvements ([98f9c1c](https://github.com/lpchaim/nixos/commit/98f9c1c53c0c773771ae3f2204513bf699e36660))
* Keyboard improvements ([cb283c9](https://github.com/lpchaim/nixos/commit/cb283c92fcce6165921e6f60cf6cfd76e9e5cf28))
* Migrate devShells to flake-parts module + git-hooks-nix ([82a8b2b](https://github.com/lpchaim/nixos/commit/82a8b2bb67b8b0262d63ef93fd596a962bd7cba8))
* Migrate from grub to systemd-boot, add boot utilities ([9b30ef4](https://github.com/lpchaim/nixos/commit/9b30ef49127ac94f23b8b9a76805021eef3e4a9b))
* Migrate to flake-parts ([e5c9dc0](https://github.com/lpchaim/nixos/commit/e5c9dc068f0740fcc493b53202991030dd2ca780))
* Misc desktop tweaks ([79ceb88](https://github.com/lpchaim/nixos/commit/79ceb888957e279f1e93695911973637c5972215))
* Move binary cache configs to new shared lib ([fbbd6b9](https://github.com/lpchaim/nixos/commit/fbbd6b911c444ab0a1444523e1732033cefddad0))
* **networking/tailscale:** Add unattended tailscale deployment ([d258446](https://github.com/lpchaim/nixos/commit/d2584468712ebe8e07b9e27ec85a60fe2f772cf7))
* **nushell:** Update shell integration, add new commands ([3f1ea24](https://github.com/lpchaim/nixos/commit/3f1ea24d07a9ff197232fc083c53eb1d141f89f6))
* **openrgb:** Change to package with plugins ([cee75a1](https://github.com/lpchaim/nixos/commit/cee75a1dd300b78c6c3c4cb7d70d98130e94fc10))
* Patch Brave webapps ([4b28c3f](https://github.com/lpchaim/nixos/commit/4b28c3f1c6ffc60e2f9455e922132bfcd1dbe752))
* Remove spotify in favor of spicetify ([b13d4ac](https://github.com/lpchaim/nixos/commit/b13d4ac53f027beaf8b0317acb458b0f7fd9e409))
* Restore U2F secret, fix permissions, improve security model ([f55559c](https://github.com/lpchaim/nixos/commit/f55559ca5ff270ac9bc84401f77ac539b759f065))
* Rework CI workflow ([662fbcb](https://github.com/lpchaim/nixos/commit/662fbcb6a45960d571d9f9b6b677af9f518e3914))
* **secrets:** Add secondary master key ([90acf18](https://github.com/lpchaim/nixos/commit/90acf18b1c613a5ef8a1be4d74ee0f414598cf29))
* Security improvements ([c64bf45](https://github.com/lpchaim/nixos/commit/c64bf45a26287944b9781fc8a9870b7cbcff3994))
* Steam tweaks ([1445a23](https://github.com/lpchaim/nixos/commit/1445a23a7165f1faccab9c176bbdb39537ef5f92))
* **steamdeck:** Create deck home, update age key ([d1ef80a](https://github.com/lpchaim/nixos/commit/d1ef80a41eaa467475a0eda042808a702d004e62))
* **storage:** Extract default BTRFS disko configuration to a function ([72ea0e9](https://github.com/lpchaim/nixos/commit/72ea0e97ed6a285aa36f9b79405594b25c2c29b1))
* Update wallpaper and profile picture ([ad06e95](https://github.com/lpchaim/nixos/commit/ad06e952cd160d989e622ca45d0c16689cc2b6be))
* Update wallpaper, better asset loading logic ([4721148](https://github.com/lpchaim/nixos/commit/47211484abd18c3b13c7f3417391a8bdf18bafb2))
* Use vesktop in place of discord ([538ef8b](https://github.com/lpchaim/nixos/commit/538ef8b1b04592d823db42f94bf07edeb3015a8c))
* Weekly flake update CI action ([08bc985](https://github.com/lpchaim/nixos/commit/08bc985ef01191a725212dcc621e11a17c0c99d6))
* **zellij:** Config tweaks ([9b7f5d7](https://github.com/lpchaim/nixos/commit/9b7f5d7e1b147fda0445607f3725f612f79d6870))
* **zellij:** Initial zellij implementation ([fe617d1](https://github.com/lpchaim/nixos/commit/fe617d11e03e7fb758e8c999d68702aaad2b6226))


### Bug Fixes

* Actually enable NVIDIA drivers ([3d39d89](https://github.com/lpchaim/nixos/commit/3d39d89b09a7cf5c3979030f0d797ea55538b6e8))
* Astal input ([e6a08f8](https://github.com/lpchaim/nixos/commit/e6a08f85d0a56d54258b513e0b29eb596772286a))
* aylur-dotfiles/astal ([b19a755](https://github.com/lpchaim/nixos/commit/b19a75507e301bb09d49c00a7c8e7398b8215234))
* CI matrix includes is supposed to be include ([692e6b1](https://github.com/lpchaim/nixos/commit/692e6b142c72bc48b0336830f30e8be7b68ba512))
* Cursor theme ([1f494f7](https://github.com/lpchaim/nixos/commit/1f494f781d1aba019ea45a3bba8dfc14983d4f2e))
* Disable pcscd ([e937ac0](https://github.com/lpchaim/nixos/commit/e937ac0818e7a4ab6aef3072f927c9c1620684fe))
* Empty packages in build CI action ([a5242e8](https://github.com/lpchaim/nixos/commit/a5242e89bf99999f7f2aee68b32920438361120a))
* Empty packages on CI, hopefully for good ([f74c2b6](https://github.com/lpchaim/nixos/commit/f74c2b63ef3c5f6d470ea80bfea9c702485806d5))
* Fix binary caches oopsie ([dd15497](https://github.com/lpchaim/nixos/commit/dd15497f841f75f373588cc2c9681aa38fa6ef3a))
* Fix default compose key ([9ab4eb0](https://github.com/lpchaim/nixos/commit/9ab4eb0da46d9e3a9766b032854e73f6d66c6166))
* Fix omnix-cli input ([f276681](https://github.com/lpchaim/nixos/commit/f276681a3cab8dc64ebb084605f1704c66aaa90c))
* **fwupd:** Move from laptop trait to generic ([604e4ed](https://github.com/lpchaim/nixos/commit/604e4ed183a9f907c6e16c03e0044726eba9072d))
* **gnome:** Fix default theming settings conflict ([ebef695](https://github.com/lpchaim/nixos/commit/ebef695adc6d7afbccd0855802e9f852656bf3bd))
* **gnome:** Tweak GNOME theming defaults and work trait ([3b5de31](https://github.com/lpchaim/nixos/commit/3b5de319897e7b7df7a5d6419ea7b7e168a6e8bb))
* **hyprland:** Clean up portal settings ([217d74d](https://github.com/lpchaim/nixos/commit/217d74d372fcaf46cd3ad133b3a7c1caf9c888dd))
* **hyprland:** Enable high refresh rate by default ([d097f57](https://github.com/lpchaim/nixos/commit/d097f57f24363da01c34cde86d6639aaf2fed124))
* **hyprland:** Misc hyprland fixes ([6cb5fdc](https://github.com/lpchaim/nixos/commit/6cb5fdcf0d8c300f23094ca4d96338d720ef8126))
* **just:** Refactor deprecated string type ([a3c0aab](https://github.com/lpchaim/nixos/commit/a3c0aabd0c21d070c63800778516abc832fb292f))
* Make it so Steam Deck overlays only affect their host ([4af3ea3](https://github.com/lpchaim/nixos/commit/4af3ea31a4efad159079a209a772d978a6472f08))
* Make omnix-cli x86_64 only ([1e90e56](https://github.com/lpchaim/nixos/commit/1e90e56d59c7eab8a54c770a31b240f57ddb02f1))
* Nix max-jobs setting ([72cfa64](https://github.com/lpchaim/nixos/commit/72cfa64b435ae7edf25ddbafdae282009e351602))
* **nushell:** Fix nushell ls aliases ([537cf7d](https://github.com/lpchaim/nixos/commit/537cf7d7ebe1076f35b911ec09a8ae0a3235aff9))
* Properly coalesce missing CI outputs to empty list ([73bae09](https://github.com/lpchaim/nixos/commit/73bae093d302082e26f192ad6097f8d69cd16446))
* Remove centralized U2F auth file ([a4b998f](https://github.com/lpchaim/nixos/commit/a4b998fcec2380f925343947783479b925a6a7f6))
* Remove obsolete packages ([bb7c89b](https://github.com/lpchaim/nixos/commit/bb7c89b863ec7446213d4464f5eed0f48d77e146))
* Remove steam deck modules from global imports ([512edb0](https://github.com/lpchaim/nixos/commit/512edb03858746c79e8abdaf6d471f5916ac3b91))
* Set fixed U2F origin and appid, change second key to requisite ([62890ca](https://github.com/lpchaim/nixos/commit/62890caa7be56e8e346d705f7f05f18ea0c91abc))
* **stylix:** Explicitly enable stylix ([2b770f3](https://github.com/lpchaim/nixos/commit/2b770f31ee823ecf686e02757794056401914405))
* System not specified in build-raspberrypi workflow step ([13e9cf0](https://github.com/lpchaim/nixos/commit/13e9cf02aade6868ca0816f62bffa74d59407ffd))
* Try to fix empty CI packages matrix again ([fdd82fc](https://github.com/lpchaim/nixos/commit/fdd82fc726640e6b0a0e1f219758060065178b45))
* Update flake input action ([46eaccc](https://github.com/lpchaim/nixos/commit/46eaccc736aadd4cac3e0c77b1ff1ada6dcf1d0f))

## [0.2.0](https://github.com/lpchaim/nixos/compare/v0.1.0...v0.2.0) (2024-06-28)


### Features

* Misc tweaks ([eb69e65](https://github.com/lpchaim/nixos/commit/eb69e653cd2a2cb2be7aa919bd937e2bf7736e1c))
* **shell:** Add generic rust development shell ([fc15b51](https://github.com/lpchaim/nixos/commit/fc15b51a3c02c341d3097bfbc8f94248e854595f))

## [0.1.0](https://github.com/lpchaim/nixos/compare/v0.0.2...v0.1.0) (2024-06-27)


### Features

* Add wifi network priority ([aedadee](https://github.com/lpchaim/nixos/commit/aedadeec89ebbe7bcefa2cbe51e2a066b4e6b507))
* Enable btrfs auto scrub ([63b843c](https://github.com/lpchaim/nixos/commit/63b843cae518de2654cefebb6d718ed0bae0d230))
* Enable weekly fstrim ([a53cd9a](https://github.com/lpchaim/nixos/commit/a53cd9a621605faff765ece369dcbedfd2430188))
* Enable zramSwap ([26f5c74](https://github.com/lpchaim/nixos/commit/26f5c74a6730212f08fa202478ffe69dfcb99c79))
* Enhance rofi configuration ([a2a155d](https://github.com/lpchaim/nixos/commit/a2a155d258aaa08209e3ccc30f3fbb2bd248ac47))


### Bug Fixes

* Hyprland fixes ([cd766fd](https://github.com/lpchaim/nixos/commit/cd766fd78addb55e4c26cedf03ec30f4b3443d8e))
* **hyprland:** Enable window focusing on activate ([dfd4988](https://github.com/lpchaim/nixos/commit/dfd49887368ebb7b0b79b8a81c028d21c099ff08))

## 0.0.1 (2024-06-16)


### Features

* Absorb home-manager repo ([def6665](https://github.com/lpchaim/nixos/commit/def66650bafae01c0de456ce3cec69b46e82a90f))
* Add devenv ([67bb7c6](https://github.com/lpchaim/nixos/commit/67bb7c67b6b34b066b145c6471ebd111e3c95861))
* Add devenv, add user and wheel group to trusted users by default ([68deafa](https://github.com/lpchaim/nixos/commit/68deafa96c02d85177a7b8367620c9e0bce9e12b))
* Add fprintd to laptop trait ([2538543](https://github.com/lpchaim/nixos/commit/2538543d56afd33926c4df92dd7249e646622618))
* Add gaming flake ([94796d5](https://github.com/lpchaim/nixos/commit/94796d5b9280d31da4e173a6797309873e85c0a1))
* Add GNOME Photos to GNOME trait ([a85b9a2](https://github.com/lpchaim/nixos/commit/a85b9a2d962247ec6365cca6248e9431106634d8))
* Add grub configuration limit ([22db465](https://github.com/lpchaim/nixos/commit/22db4651142eb0da0d63e31f446ebd03e09d2a04))
* Add hishtory ([0071f4c](https://github.com/lpchaim/nixos/commit/0071f4c601f27611eb3bb61c00f14d2cfd591b8b))
* Add KDE Plasma trait ([ba3ffae](https://github.com/lpchaim/nixos/commit/ba3ffae3d3800596405e6e0341768111ebf82c98))
* Add media trait ([b3df812](https://github.com/lpchaim/nixos/commit/b3df812f4f93c3efb86a7e4bd8bdd7ff94482b9c))
* Add nix-community cachix substituter ([5211f40](https://github.com/lpchaim/nixos/commit/5211f408a918e9dc23d4df74d9b6caaae3bb76b1))
* Add nix-output-monitor ([384040f](https://github.com/lpchaim/nixos/commit/384040f410c30bcc00e82c45f93a404eb7cdc880))
* Add NixOS Software Center ([7f559f0](https://github.com/lpchaim/nixos/commit/7f559f068bffd577611ba6a988ce94bb65d75a85))
* Add NUR ([9ec84ca](https://github.com/lpchaim/nixos/commit/9ec84ca48b0ff734d75a2dd2858afc004d5b2b6d))
* Add PHP debugger to work config ([6c0d997](https://github.com/lpchaim/nixos/commit/6c0d997b030ad1a1c0ac82156b3e8a5b63aa73a6))
* Add protontricks to gaming trait ([d991603](https://github.com/lpchaim/nixos/commit/d9916033cb0cef2aa25061f5e2ee26a09b0a6fe9))
* Add silver-searcher (ag) ([fba326d](https://github.com/lpchaim/nixos/commit/fba326d3c137b728cbf1679b09a5b2665414214d))
* Add snowfallorg/flake ([05fb3be](https://github.com/lpchaim/nixos/commit/05fb3be716725f6b0f3cf0f37503d382f894ed98))
* Add stylix, inputs refactor ([7c6fbf9](https://github.com/lpchaim/nixos/commit/7c6fbf97b7c3d018299cce5916eff2be32f5018c))
* Add tailscale ([9f2be37](https://github.com/lpchaim/nixos/commit/9f2be374e1cbb8ef1487f2c28780828a29625598))
* Add virtualization trait ([dbbe774](https://github.com/lpchaim/nixos/commit/dbbe77464e0a145264444a780e222d7c58320637))
* Add Waydroid and helper script ([4514f69](https://github.com/lpchaim/nixos/commit/4514f690e7c2f55a9431638473b5de2cbda35c40))
* Add wl-clipboard ([2e93a7e](https://github.com/lpchaim/nixos/commit/2e93a7edf2e9ad954d064b73ab7010526d714676))
* Add work devShell ([d8b1298](https://github.com/lpchaim/nixos/commit/d8b129860755cc63cb83296e40e565ca0f766956))
* Add WSL home configuration ([0ad9950](https://github.com/lpchaim/nixos/commit/0ad995065c4ccb94003a34c49d70925920522a4b))
* Add WSL SOPS key ([478da6b](https://github.com/lpchaim/nixos/commit/478da6b22db2166554f3fb064ab70ec02ac56202))
* Add zen kernel trait ([372dffb](https://github.com/lpchaim/nixos/commit/372dffb2d259798bf926ed0cd7b7bee365ae9ac2))
* auto-cpufreq tweaks ([6126b06](https://github.com/lpchaim/nixos/commit/6126b06053f4f88cef88629c52e06fb54922fcd2))
* Basic Hypridle and Hyprlock configs, theme improvements ([89e9aff](https://github.com/lpchaim/nixos/commit/89e9aff700ceb257943bf99b77dafabb163e9a33))
* Boot tweaks ([b975ef0](https://github.com/lpchaim/nixos/commit/b975ef0d5deaa708f7abff22314d75bcdeaa7148))
* Change bootloader to GRUB ([6f6c282](https://github.com/lpchaim/nixos/commit/6f6c2826107725919960aa04f9fbb1b04ffff5a6))
* Enable auto garbage collection ([481716c](https://github.com/lpchaim/nixos/commit/481716c681c8d323d835b5d1ffbb78acd577189b))
* Enable firewall ([ed4443b](https://github.com/lpchaim/nixos/commit/ed4443b024a8e7296cfb1708ccae00d0f0a0cce8))
* **helix:** Restore old copy to system clipboard behavior ([067f1a8](https://github.com/lpchaim/nixos/commit/067f1a8c779679e470f7df4a806531bde060d051))
* Initial configuration ([bc16626](https://github.com/lpchaim/nixos/commit/bc1662636fc62a8d560cf5741a60a6d53a7cd2fe))
* Initial configuration ([7430ae1](https://github.com/lpchaim/nixos/commit/7430ae101c8dc6f82aa1c213d595b3bf6b7bf27e))
* Initial Hyprland + AGS support ([4fccc0e](https://github.com/lpchaim/nixos/commit/4fccc0e3eb25cc57aecb1fc4ce18888d97b92984))
* Initial LLM module ([86407e7](https://github.com/lpchaim/nixos/commit/86407e7620bd0cb9871a6ec70c33f7f66a1d87c6))
* Kernel tweaks ([b2eb71e](https://github.com/lpchaim/nixos/commit/b2eb71ea7a934c68997afed3c17eb567b0572b97))
* Migrate to snowfall-lib ([d403748](https://github.com/lpchaim/nixos/commit/d403748a5341926f552621ea505f8b0a47ded85a))
* Misc config tweaks ([12c9d2b](https://github.com/lpchaim/nixos/commit/12c9d2b8c53d3c95a1b81cec513c71705ce06bee))
* Nushell enhancements ([322d2db](https://github.com/lpchaim/nixos/commit/322d2db04c4307291b14ee263dfee0d096b8458a))
* Pipewire tweaks ([9737770](https://github.com/lpchaim/nixos/commit/9737770f1473c23daa5f0fa8c5b322bd4ecbfc66))
* Simplify DE configuration ([874d636](https://github.com/lpchaim/nixos/commit/874d636a467ea115913cd280d04366517cfc628d))
* SOPS secrets management + immutable users ([cc6ccf8](https://github.com/lpchaim/nixos/commit/cc6ccf83ca6f0a322092ffe3d6ca4646440c7ee6))
* **tmux:** Disable detach on destroy ([2476348](https://github.com/lpchaim/nixos/commit/2476348d3a3387866b6ba66190af32593314d274))
* Tweak rofi icons ([09166f5](https://github.com/lpchaim/nixos/commit/09166f54901663ce7f2de398be81327b52ad4220))


### Bug Fixes

* Allow Spotify ports on firewall ([257f23b](https://github.com/lpchaim/nixos/commit/257f23bfd8f0319b193e8d9cdb85a0b34fe95144))
* Bluetooth controllers ([41eee92](https://github.com/lpchaim/nixos/commit/41eee92891bbc6cdb82c18dc5747bfe406aa2d98))
* Default theming exclusions ([382dfb8](https://github.com/lpchaim/nixos/commit/382dfb8fd29847a08008d77da01c8300ecd657fc))
* Disable DE theming on work trait ([3c8d6a0](https://github.com/lpchaim/nixos/commit/3c8d6a029a48a39cf94f61d6768a8af4f6ceccff))
* Flake enhancements ([0b270c4](https://github.com/lpchaim/nixos/commit/0b270c4627b6eef557a8e2c89b56a8d563e40e48))
* **flake:** Misc tweaks ([968ffe0](https://github.com/lpchaim/nixos/commit/968ffe0ac3ca3df5143a74ac7e4d4cc0178368ff))
* **gnome:** Prefer dark theme settings ([8149ac0](https://github.com/lpchaim/nixos/commit/8149ac09bd5d7c9df6868d9a8572345a263efcfa))
* Hishtory ctrl+R handling ([2c83e61](https://github.com/lpchaim/nixos/commit/2c83e61e81b1b692e28718446c01782abbefbeb4))
* Remove DE settings from cheina trait ([cc1cde1](https://github.com/lpchaim/nixos/commit/cc1cde12504e35a448f321a0258ad559a3ce571c))
* Remove useless rec ([3819aa8](https://github.com/lpchaim/nixos/commit/3819aa8fee488ad0eb2e4549ef69e9a420f237e1))
* Restore nil to default shell packages ([173a99e](https://github.com/lpchaim/nixos/commit/173a99ec11d976848fef6aa679eaa456e92c81fd))
* Stylix wallpaper default value set as store path ([6a19eed](https://github.com/lpchaim/nixos/commit/6a19eedad118596b5ce7f7ab5c94f28ffdc3a4bb))


### Miscellaneous Chores

* Release 0.0.1 ([eb95fa0](https://github.com/lpchaim/nixos/commit/eb95fa0688e91adf1e96e078fd014556a8069ede))
