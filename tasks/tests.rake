namespace :tests do
  desc "Setup tests"
  task :setup do
    section "Setting up the tests"

    if testing?
      DOTS_FOLDER = 'dotfiles'
    end
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/app_store.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/mas/app_store.txt)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/default-python-packages.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/asdf/default-python-packages.txt)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/default-gems.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/asdf/default-gems.txt)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/taps.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/homebrew/taps.txt)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/.mackup.cfg #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tools/mackup/mackup.cfg)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/packages.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/homebrew/packages.txt)
    run %( cp #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/tests/stubs/cask.txt #{DIRECTORY_NAME + File::SEPARATOR + DOTS_FOLDER}/package-managers/homebrew/cask.txt)
  end
end
