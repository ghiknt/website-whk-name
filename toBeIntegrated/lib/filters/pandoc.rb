class PandocCommandLine < Nanoc::Filter
  identifier :pandoc_commandline
  type :text
  def run(content, params={})
   filter = ::Nanoc::Filters::Pandoc.new
   filter.setup_and_run(content, *params[:args])
  end
end
