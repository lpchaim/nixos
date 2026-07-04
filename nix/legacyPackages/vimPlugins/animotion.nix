{
  fetchFromGitHub,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "animotion";
  version = "unstable-2026-02-27";
  src = fetchFromGitHub {
    owner = "luiscassih";
    repo = "AniMotion.nvim";
    rev = "main";
    hash = "sha256-Ro+Nic4v2oR60p/rE3vm0iDCNU+EtkSKAiTHkp19WB8=";
  };
}
