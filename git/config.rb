#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../_lib/helper.rb'

DEFAULT_CONFIG = {
  'alias.br' => 'branch',
  'alias.co' => 'checkout',
  'alias.pick' => 'cherry-pick',
  'alias.st' => 'status',
  'alias.when' => 'blame',

  'alias.l1' => 'log --pretty=oneline',
  'alias.lg' => 'log --decorate=short --date-order --graph --date=iso',
  'alias.mm' => 'merge --no-ff',
  'alias.ff' => 'merge --ff-only',
  'alias.amend-new' => 'commit --amend --reset-author',
  'alias.cached' => 'diff --cached',
  'alias.unadd' => 'reset HEAD --',
  'alias.initcommit' => '!git init && git commit -m Init --allow-empty',

  'color.ui' => 'auto',
  'color.diff' => 'auto',
  'color.branch' => 'auto',
  'color.status' => 'auto',

  'core.fileMode' => 'true',
  'core.fsyncObjectFiles' => 'true',
  'core.quotePath' => 'false',

  'diff.renames' => 'copies',

  'push.default' => 'current',
}.freeze

def git_config(key, value, global = true)
  run_command(['git', 'config', ('--global' if global), key, value])
end

def main
  configs = DEFAULT_CONFIG.dup

  heading 'Customising'
  if prompt_yn 'Edit commit messages with GUI vim?'
    configs['core.editor'] = 'gvim --nofork'
  end
  if prompt_yn 'Check integrity when pulling?'
    configs['transfer.fsckObjects'] = 'true'
  end

  heading 'Confirming'
  configs.sort.each do |key, val|
    puts "Set: #{PINK}#{key.shellescape}#{OFF} = #{CYAN}#{val.shellescape}#{OFF}"
  end
  return false unless prompt_yn('Apply this configuration?')

  heading 'Applying configuration'
  configs.each do |key, val|
    git_config(key, val)
  end
  true
end

exit(main) if $PROGRAM_NAME == __FILE__
