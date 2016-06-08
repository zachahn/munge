module ExtractData
  def extract_data(name)
    file     = caller_locations(1, 1).first.absolute_path
    contents = File.read(file)
    post_end = contents.split(/^__END__$/, 2).last || ""
    sections =
      post_end
        .split(/^@@\s*/)
        .map(&:rstrip)
        .map { |section| section.split("\n", 2) }
        .map { |key, value| [key, value] }
        .to_h

    found_section = sections[name]

    if found_section.nil?
      return nil
    end

    extracted_section = found_section.sub(/^\n*/, "")

    if extracted_section[-1] == "\n"
      extracted_section
    else
      extracted_section + "\n"
    end
  end
end
