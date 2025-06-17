#!/usr/bin/env dart

import 'dart:math';
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../lib/password_manager.dart';

class ValidateCommand extends Command<void> {
  @override
  final name = 'validate';
  @override
  final description = 'Validate the strength of a password.';

  ValidateCommand() {
    argParser.addFlag('help', abbr: 'h', negatable: false, help: 'Display help info for validate.');
  }

  @override
  void run() {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      printUsage();
      exitCode = 64;
      return;
    }
    final pm = PasswordManager();
    final result = pm.validatePassword(rest.first);
    stdout.writeln('Password Strength: $result');
  }
}

class GenerateCommand extends Command<void> {
  @override
  final name = 'generate';
  @override
  final description = 'Generate a password (strong, intermediate, low).';

  GenerateCommand() {
    argParser.addOption('level',
        abbr: 'l',
        allowed: ['strong', 'intermediate', 'low'],
        defaultsTo: 'strong',
        help: 'Strength level');
    argParser.addFlag('help', abbr: 'h', negatable: false, help: 'Display help info for generate.');
  }

  @override
  void run() {
    final level = argResults!['level'] as String;
    final pm = PasswordManager();
    final password = pm.generatePassword(level);
    stdout.writeln('Generated Password [$level]: $password');
  }
}

void main(List<String> args) {
  final runner = CommandRunner<void>(
      'lock_and_key', 'A CLI tool to validate and generate passwords.')
    ..addCommand(ValidateCommand())
    ..addCommand(GenerateCommand());

  runner.run(args).catchError((error) {
    if (error is UsageException) {
      stdout.writeln(error);
      exit(64);
    } else {
      stderr.writeln('Error: $error');
      exit(1);
    }
  });
}
