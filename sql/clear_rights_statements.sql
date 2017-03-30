# The migration plugin interprets rightsTransferred="True" as a copyright statement, so we need to clear
# the rights_statement table after migration. At the time of migration table contains only these incorrectly generated
# copyright statements.

DELETE FROM rights_statement;
