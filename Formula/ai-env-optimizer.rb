class AiEnvOptimizer < Formula
  desc "macOS health and maintenance CLI for AI coding environments"
  homepage "https://github.com/nyldn/ai-env-optimizer"
  url "https://github.com/nyldn/ai-env-optimizer/releases/download/v0.3.0/ai-env-optimizer-0.3.0.tar.gz"
  sha256 "40750ea629052b8e9b9ce367c5029d1d04b846f25b2460adba6ec7e3e563aaee"
  license "MIT"

  depends_on macos: :ventura
  depends_on "ruby"

  def install
    inreplace "bin/ai-env-optimizer",
              "#!/usr/bin/env ruby",
              "#!#{formula_opt_bin("ruby")}/ruby"
    bin.install "bin/ai-env-optimizer"
    bin.install_symlink "ai-env-optimizer" => "ai-optimizer"
    lib.install "lib/ai_optimizer.rb", "lib/ai_optimizer"
    prefix.install "VERSION"
  end

  service do
    name macos: "homebrew.mxcl.ai-optimizer"
    run [opt_bin/"ai-env-optimizer", "run-maintenance"]
    run_type :cron
    cron "30 19 * * *"
    run_at_load false
    process_type :background
  end

  test do
    assert_match "ai-env-optimizer #{version}", shell_output("#{bin}/ai-env-optimizer version")
    assert_match "ai-env-optimizer #{version}", shell_output("#{bin}/ai-optimizer version")
    output = shell_output("#{bin}/ai-env-optimizer doctor --json")
    assert_match '"product":"ai-env-optimizer"', output
    assert_match '"legacy_names":["ai-optimizer"]', output
    assert_match '"schema_version":1', output
    assert_match '"id":"desktop.claude.present"', output
    assert_match '"id":"desktop.codex.present"', output

    agent_output = shell_output("#{bin}/ai-env-optimizer agent-context --json --workspace-root #{testpath}")
    assert_match '"mode":"read_only_advisor"', agent_output
    assert_match '"prioritized_actions":', agent_output

    storage_output = shell_output("#{bin}/ai-env-optimizer storage --json")
    assert_match '"product":"ai-env-optimizer"', storage_output
    assert_match '"summary":', storage_output

    service_plist = service.to_plist
    assert_match %r{<string>homebrew\.mxcl\.ai-optimizer</string>}, service_plist
    command_pattern = %r{
      <string>#{Regexp.escape(opt_bin.to_s)}/ai-env-optimizer</string>\s*
      <string>run-maintenance</string>
    }x
    assert_match command_pattern, service_plist
    assert_match %r{<key>RunAtLoad</key>\s*<false/>}, service_plist
    assert_match %r{<key>Hour</key>\s*<integer>19</integer>}, service_plist
    assert_match %r{<key>Minute</key>\s*<integer>30</integer>}, service_plist
  end
end
