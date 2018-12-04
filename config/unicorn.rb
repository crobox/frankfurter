# frozen_string_literal: true

worker_process_count = (ENV['WORKER_PROCESSES'] || 4).to_i

preload_app true
worker_processes worker_process_count
timeout 10

initialized = false
before_fork do |_server, _worker|
  Sequel::DATABASES.each(&:disconnect)
  unless initialized
    require 'scheduler/daemon'
    Scheduler::Daemon.start
    initialized = true
  end
end
