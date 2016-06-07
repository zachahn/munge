module ExtractData
  def extract_data(name)
    file     = caller_locations(1, 1).first.absolute_path
    contents = File.read(file)
    post_end = contents.split(/^__END__$/, 2).last || ""
    matches  = post_end.strip.match(/(?:(@@\s*[^\n]*)\n([^(@@)]+)+)/m).to_a
    sections =
      post_end
        .split(/^@@\s*/)
        .map(&:rstrip)
        .select { |s| s.length > 0 }
        .map    { |section| section.split("\n", 2) }
        .to_h

    sections[name].sub(/^\n*/, "") + "\n"
  end
end
