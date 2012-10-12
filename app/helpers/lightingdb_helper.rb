module LightingdbHelper

  def lantern_page(lantern, pageid)
  # Create a hierachy of LightingdbPage representing:
  # showlantern
  #  |-showgobos
  #  |-showerrors
    pages = {}
    info = {:manufacturer => lantern.manufacturer.name, :lantern => lantern.name}
    pages[:showlantern] = ShellPage.new(lantern.name,
                                                      Comatose::PageWrapper.create_from_slug("lightingdb"),
                                                      showlantern_url(info))
    if lantern.gobo_wheels.first
      pages[:showgobos] = ShellPage.new(lantern.name + " Gobos",
                                                      pages[:showlantern],
                                                      showgobos_url(info), "Gobos")
    end
    if lantern.error_messages.first
      pages[:showerrors] = ShellPage.new(lantern.name + " Errors",
                                                       pages[:showlantern],
                                                       showerrors_url(info), "Errors")
    end
    return pages[pageid]
  end
  
end