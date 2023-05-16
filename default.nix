with (import <nixpkgs> {} );
let
  packer-builder-arm = buildGoModule rec {
    pname = "packer-builder-arm";
    version = "1.0.6";
    src = fetchFromGitHub {
      owner = "mkaczanowski";
      rev = "v${version}";
      repo = "packer-builder-arm";
      sha256 = "sha256-QBfpPygTkTT06bO3aI8sZBGd1LlmqAQRp8FltDIFwME=";
    };
    vendorSha256 = "sha256-S8N8qajgSDqTJm2oBwPhmxymIiAD4/foeXjlk3roljs=";
  };
in pkgs.mkShell {
  buildInputs = [
    packer-builder-arm
    packer
  ];
}
