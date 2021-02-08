<?php

/*
 * This script creates a .env file that dotenv can then read later (owned by www-data user).
 * This script will be executed on startup by the user that will have access to the environment
 * variables passed into docker by -e or --env-file
 * We only write out the variables we expect, rather than all variables as testing showed
 * that just dumping output of env to .env caused dotenv to fail.
 */

$env = shell_exec("env");

$epectedEnvironmentVariables = array(
    "USER_NAME",
);

$lines = explode(PHP_EOL, $env);

foreach ($lines as $index => $line)
{
    $parts = explode("=", $line);

    if (in_array($parts[0], $epectedEnvironmentVariables) === false)
    {
        unset($lines[$index]);
    }
}

$envFile = implode(PHP_EOL, $lines);
file_put_contents("/.env", $envFile);
chown("/.env", "www-data");