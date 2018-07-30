# -*- mode: ruby -*-
# vi: set ft=ruby :

# mostly copied from https://github.com/Moya/Moya/blob/master/Dangerfile
# and https://github.com/artsy/eigen/blob/master/Dangerfile

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include?("#trivial") || github.pr_body.include?("#trivial")
has_app_changes = !git.modified_files.grep(/TRiOS/).empty?

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "WIP"

# Oi, CHANGELOGs please
fail("No CHANGELOG changes made") if git.lines_of_code > 50 && !git.modified_files.include?("CHANGELOG.md") && !declared_trivial

# Stop skipping some manual testing
warn("Needs testing on a Phone if change is non-trivial") if git.lines_of_code > 50 && !github.pr_title.include?("📱")

# Warn when library files has been updated but not tests.
tests_updated = !git.modified_files.grep(/^*Spec.swift$/).empty?
if has_app_changes && !tests_updated
  warn("The app files were changed, but the tests remained unmodified. Consider updating or adding to the tests to match the app changes.")
end

# Run SwiftLint
swiftlint.lint_files inline_mode: true
