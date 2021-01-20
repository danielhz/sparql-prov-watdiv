# Tasks are defined in separate files.

require 'fileutils'

# require './config/config.rb'

def task_dependency(task_name)
  "task_status/done_#{task_name}"
end

def named_task(task_name, *dependencies)
  done_task = task_dependency(task_name)
  started_task = "task_status/started_#{task_name}"

  file done_task => dependencies do
    time = Time.now
    FileUtils.touch started_task

    yield

    File.open(started_task, 'w') { |f| f.puts "#{Time.now - time}" }
    FileUtils.mv started_task, done_task
  end
end

Rake.add_rakelib 'rakelib'

task :default => 'task_status/done_get_dataset_10M'
