require "capybara/minitest"

Capybara.register_driver(:vscode) do |app|
  options = { browser: :remote, url: "http://selenium-vscode:4444/wd/hub" }

  options[:desired_capabilities] = Selenium::WebDriver::Remote::Capabilities.chrome(
    chrome_options: {
      binary: "/opt/vscode_wrapper",
      args: ["before-boot='echo \"{ \\\"ruby-lsc.commandWithArgs\\\": [ \\\"nc\\\", \\\"#{Socket.gethostname}\\\", \\\"12345\\\" ] }\" > .vscode/settings.json'"],
    },
  )

  Capybara::Selenium::Driver.new(app, options)
end

Capybara.run_server = false
Capybara.default_driver = :vscode
Capybara.default_max_wait_time = 5
