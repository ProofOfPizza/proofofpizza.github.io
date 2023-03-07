{ pkgs ? import <pkgs-unstable> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    ruby
    dig
    jekyll
    heroku
  ];
}
