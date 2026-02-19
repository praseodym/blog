{
  description = "Zola blog development environment and build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell with Zola and useful tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zola  # Static site generator
            git   # Version control
          ];

          shellHook = ''
            echo "🚀 Zola development environment loaded!"
            echo ""
            echo "Available commands:"
            echo "  zola serve    - Start development server with live reload"
            echo "  zola build    - Build the static site"
            echo "  zola check    - Check content and templates"
            echo ""
            echo "Zola version: $(zola --version)"
          '';
        };

        # Package for building the static site
        packages = {
          # Build the Zola site
          default = pkgs.stdenv.mkDerivation {
            name = "blog";
            src = ./.;

            buildInputs = [ pkgs.zola ];

            buildPhase = ''
              zola build
            '';

            installPhase = ''
              mkdir -p $out
              cp -r public/* $out/
            '';

            meta = with pkgs.lib; {
              description = "praseodym.net/blog - Personal blog built with Zola";
              homepage = "https://www.praseodym.net/blog";
              license = licenses.cc-by-40;
            };
          };

          # Just build without installing (useful for CI)
          build = pkgs.stdenv.mkDerivation {
            name = "blog-build";
            src = ./.;

            buildInputs = [ pkgs.zola ];

            buildPhase = ''
              zola build
            '';

            installPhase = ''
              mkdir -p $out
              cp -r public $out/
            '';
          };
        };

        # Apps for convenience
        apps = {
          # Serve the blog locally
          serve = {
            type = "app";
            program = toString (pkgs.writeShellScript "serve" ''
              ${pkgs.zola}/bin/zola serve
            '');
          };

          # Build the blog
          build = {
            type = "app";
            program = toString (pkgs.writeShellScript "build" ''
              ${pkgs.zola}/bin/zola build
            '');
          };

          # Check the blog
          check = {
            type = "app";
            program = toString (pkgs.writeShellScript "check" ''
              ${pkgs.zola}/bin/zola check
            '');
          };
        };

        # Checks for CI
        checks = {
          # Verify the blog builds successfully
          build = self.packages.${system}.default;

          # Run Zola check
          zola-check = pkgs.stdenv.mkDerivation {
            name = "zola-check";
            src = ./.;

            buildInputs = [ pkgs.zola ];

            buildPhase = ''
              zola check
            '';

            installPhase = ''
              mkdir -p $out
              echo "Zola check passed" > $out/result
            '';
          };
        };
      }
    );
}
