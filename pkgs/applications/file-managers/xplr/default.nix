{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lqFhLCOLiuSQWhbcZUEj2xFRlZ+x1ZTVc8IJw7tJjhE=";
  };

  cargoHash = "sha256-3hrpg2cMvIuFy6mH1/1igIpU4nbzFQLCAhiIRZbTuaI=";

  # fixes `thread 'main' panicked at 'cannot find strip'` on x86_64-darwin
  env = lib.optionalAttrs (stdenv.isx86_64 && stdenv.isDarwin) {
    TARGET_STRIP = "${stdenv.cc.targetPrefix}strip";
  };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config
  '';

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g mimame ];
  };
}
