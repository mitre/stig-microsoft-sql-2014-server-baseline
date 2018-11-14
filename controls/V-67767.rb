
ALLOWED_AUDIT_PERMISSIONS = attribute('allowed_audit_permissions')

control "V-67767" do
  title "Where SQL Server Audit is in use, SQL Server must allow only the ISSM
  (or individuals or roles appointed by the ISSM) to select which auditable
  events are to be audited at the server level."
  desc  "Without the capability to restrict which roles and individuals can
  select which events are audited, unauthorized personnel may be able to prevent
  or interfere with the auditing of critical events.

      Suppression of auditing could permit an adversary to evade detection.

      Misconfigured audits can degrade the system's performance by overwhelming
  the audit log. Misconfigured audits may also make it more difficult to
  establish, correlate, and investigate the events relating to an incident or
  identify those responsible for one.

      Use of SQL Server Audit is recommended.  All features of SQL Server Audit
    are available in the Enterprise and Developer editions of SQL Server 2014.  It
    is not available at the database level in other editions.  For this or legacy
    reasons, the instance may be using SQL Server Trace for auditing, which remains
    an acceptable solution for the time being.  Note, however, that Microsoft
    intends to remove most aspects of Trace at some point after SQL Server 2016.

      This version of the requirement deals with SQL Server Audit-based audit
    trails.
  "
  impact 0.7
  tag "gtitle": "SRG-APP-000090-DB-000065"
  tag "gid": "V-67767"
  tag "rid": "SV-82257r1_rule"
  tag "stig_id": "SQL4-00-011310"
  tag "fix_id": "F-73881r1_fix"
  tag "cci": ["CCI-000171"]
  tag "nist": ["AU-12 b", "Rev_4"]
  tag "false_negatives": nil
  tag "false_positives": nil
  tag "documentable": false
  tag "mitigations": nil
  tag "severity_override_guidance": false
  tag "potential_impacts": nil
  tag "third_party_tools": nil
  tag "mitigation_controls": nil
  tag "responsibility": nil
  tag "ia_controls": nil
  tag "check": "If SQL Server Audit is not in use, this is not a finding.

  Obtain the list of approved audit maintainers from the system documentation.

  Review the server roles and individual logins that have the following
  permissions, all of which enable the ability to create and maintain audit
  definitions (the views and functions provided in the supplemental fine
  Permissions.sql can assist in this):
  ALTER ANY SERVER AUDIT
  CONTROL SERVER
  ALTER ANY DATABASE
  CREATE ANY DATABASE

  The functions and views provided in the supplemental file Permissions.sql can
  assist in this review.  In the following, \"STIG\" stands for the schema where
  you have deployed these views and functions.  To see which logins and server
  roles have been granted these permissions:
      SELECT
          *
      FROM
          STIG.server_permissions P
      WHERE
          P.[Permission] IN
          (
          'ALTER ANY SERVER AUDIT',
          'CONTROL SERVER',
          'ALTER ANY DATABASE',
          'CREATE ANY DATABASE'
          );

  To see what logins and server roles inherit these permissions from the server
  roles reported by the previous query, repeat the following for each one:
      SELECT * FROM STIG.members_of_server_role(<server role name>);

  To see all the permissions in effect for a server principal (server role or
  login):
      SELECT * FROM STIG.server_effective_permissions(<principal name>);

  If designated personnel are not able to configure auditable events, this is a
  finding.

  If unapproved personnel are able to configure auditable events, this is a
  finding."
  tag "fix": "Create a server role specifically for audit maintainers, and give
  it permission to maintain audits, without granting it unnecessary permissions:
      USE master;
      GO
      CREATE SERVER ROLE SERVER_AUDIT_MAINTAINERS;
      GO
      GRANT ALTER ANY SERVER AUDIT TO SERVER_AUDIT_MAINTAINERS;
      GO
  (The role name used here is an example; other names may be used.)

  Use REVOKE and/or DENY and/or ALTER SERVER ROLE ... DROP MEMBER ... statements
  to remove the ALTER ANY SERVER AUDIT permission from all logins.

  Then, for each authorized login, run the statement:
      ALTER SERVER ROLE SERVER_AUDIT_MAINTAINERS ADD MEMBER <login name>;
      GO

  Use REVOKE and/or DENY and/or ALTER SERVER ROLE ... DROP MEMBER ... statements
  to remove CONTROL SERVER, ALTER ANY DATABASE and CREATE ANY DATABASE
  permissions from logins that do not need them."
  #permissions = command("Invoke-Sqlcmd -Query \"SELECT Grantee, Permission FROM STIG.server_permissions P WHERE P.[Permission] IN ('ALTER ANY SERVER AUDIT', 'CONTROL SERVER', 'ALTER ANY DATABASE', 'CREATE ANY DATABASE');\" -ServerInstance '#{SERVER_INSTANCE}' | Findstr /v 'Grantee ---'").stdout.strip.split("\n")

   sql = mssql_session(user: attribute('user'),
                              password: attribute('password'),
                              host: attribute('host'),
                              instance: attribute('instance'),
                              port: attribute('port'),
                              )
    permissions = sql.query("SELECT Grantee as result FROM STIG.server_permissions P WHERE
          P.[Permission] IN
          (
          'ALTER ANY SERVER AUDIT',
          'CONTROL SERVER',
          'ALTER ANY DATABASE',
          'CREATE ANY DATABASE'
          );").column('result')

  if  permissions.empty?
    impact 0.0
    desc 'There are no users with audit permissions, control not applicable'

    describe "There are no users with audit permissions, control not applicable" do
      skip "There are no users with audit permissions, control not applicable"
    end
  else
     permissions.each do |perms|
      a = perms.strip
      describe "sql audit permissions: #{a}" do
        subject {a}
        it { should be_in ALLOWED_AUDIT_PERMISSIONS }
      end
    end
  end
end

