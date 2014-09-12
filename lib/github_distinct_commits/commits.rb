require 'octokit'

module GithubDistinctCommits
  class Commits
    def initialize(owner, repo)
      client = Octokit::Client.new(:netrc => true)
      root = client.root
      @repo = root.rels[:repository].call :uri => {:owner => owner, :repo => repo }
    end

    def commits
      @commits = @repo.data.rels[:commits]
      @commit_array = @commits.get
      until @commit_array.data.empty? do
        @commit_array.data.each do |commit|
          puts "'sha': #{commit.sha}, 'message': #{commit.message}, 'distinct': #{commit.distinct}"
        end
        @commits = @commits.get.rels[:next]
        break if @commits.nil? # TODO: what's the right way to iterate?
        @commit_array = @commits.get
      end
    end

    def events
      @events = @repo.data.rels[:events]
      @event = @events.get
      until @event.data.empty? do
        id = @event.data[0].id
        type = @event.data[0].type
        payload = @event.data[0].payload
        puts "'id': #{id}, 'type': #{type}"
        if type == 'PushEvent'
          commits = payload.commits
          commits.each do |commit|
            puts "    'sha': #{commit.sha}, 'message': #{commit.message}, 'distinct': #{commit.distinct}"
          end
        end
        @events = @events.get.rels[:next] # never gets more than one?
        @event = @events.get
      end
    end
  end
end