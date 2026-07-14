#!/usr/bin/env ruby
require "yaml"

root = File.expand_path("..", __dir__)
config = YAML.safe_load(File.read(File.join(root, "_config.yml")))
author = config.fetch("author")
template = config.fetch("template", {})
name = author.fetch("name")
email = author.fetch("email", "")
url = config.fetch("url").sub(%r{/$}, "")
repository = config.fetch("repository")
year = template.fetch("license_year", Time.now.year)

license = <<~TEXT
  MIT License

  Copyright (c) #{year} #{name}

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
TEXT

robots = "User-agent: *\nAllow: /\n\nSitemap: #{url}/sitemap.xml\n"
security_contact = email.empty? ? "GitHub private vulnerability reporting" : email
security = <<~TEXT
  # Security policy

  ## Supported version

  The `main` branch is the only supported version.

  ## Reporting a vulnerability

  Do not open a public issue. Report vulnerabilities through #{security_contact}.
TEXT

issue_config = <<~YAML
  blank_issues_enabled: false
  contact_links:
    - name: Questions and support
      url: https://github.com/#{repository}/discussions
      about: Use Discussions for support and customization questions.
YAML

files = {
  "LICENSE" => license,
  "robots.txt" => robots,
  "SECURITY.md" => security,
  ".github/ISSUE_TEMPLATE/config.yml" => issue_config
}

if ARGV.include?("--check")
  stale = files.select { |path, body| !File.exist?(File.join(root, path)) || File.read(File.join(root, path)) != body }
  abort("Not synchronized: #{stale.keys.join(', ')}") unless stale.empty?
  puts "Repository identity files are synchronized."
else
  files.each { |path, body| File.write(File.join(root, path), body) }
  domain = template.fetch("custom_domain", "").to_s.strip
  File.write(File.join(root, "CNAME"), "#{domain}\n") unless domain.empty?
  puts "Synchronized repository files for #{name}."
end
