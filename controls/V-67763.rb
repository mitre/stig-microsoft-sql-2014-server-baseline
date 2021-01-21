control 'V-67763' do
  title "SQL Server must protect against an individual using a shared account
  from falsely denying having performed a particular action."
  desc "Non-repudiation of actions taken is required in order to maintain
  application integrity. Examples of particular actions taken by individuals
  include creating information, sending a message, approving information (e.g.,
  indicating concurrence or signing a contract), and receiving a message.

      Non-repudiation protects against later claims by a user of not having
  created, modified, or deleted a particular data item or collection of data in
  the database.

      Use of shared accounts does not provide individual accountability for
  actions taken on the DBMS or data. Whenever a single database account is used
  to connect to the database, a secondary authentication method that provides
  individual accountability is required. This scenario most frequently occurs
  when an externally hosted application authenticates individual users to the
  application and the application uses a single account to retrieve or update
  database information on behalf of the individual users (as in connection
  pooling).

      When shared accounts are utilized without another means of identifying
  individual users, users may deny having performed a particular action.

      (Shared accounts should not be confused with Windows groups, which are used
  in role-based access control.)
  "
  impact 0.5
  tag "gtitle": 'SRG-APP-000080-DB-000063'
  tag "gid": 'V-67763'
  tag "rid": 'SV-82253r1_rule'
  tag "stig_id": 'SQL4-00-023700'
  tag "fix_id": 'F-73877r1_fix'
  tag "cci": ['CCI-000166']
  tag "nist": ['AU-10', 'Rev_4']
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
  tag "check": "Obtain the list of authorized SQL Server accounts in the system
  documentation.

  If accounts are determined to be shared, determine if individuals are first
  individually authenticated.

  If individuals are not individually authenticated before using the shared
  account (e.g., by the operating system or possibly by an application making
  calls to the database), this is a finding.

  The key is individual accountability. If this can be traced, this is not a
  finding.

  If accounts are determined to be shared, determine if they are directly
  accessible to end users.  If so, this is a finding.

  Review contents of audit logs, traces and data tables to confirm that the
  identity of the individual user performing the action is captured.

  If shared identifiers are found, and not accompanied by individual identifiers,
  this is a finding.

  Note:  Privileged installation accounts may be required to be accessed by the
  DBA or other administrators for system maintenance. In these cases, each use of
  the account must be logged in some manner to assign accountability for any
  actions taken during the use of the account."
  tag "fix": "Remove user-accessible shared accounts and use individual userids.

  Build/configure applications to ensure successful individual authentication
  prior to shared account access.

  Ensure each user's identity is received and used in audit data in all relevant
  circumstances.

  Design, develop, and implement a method to log use of any account to which more
  than one person has access. Restrict interactive access to shared accounts to
  the fewest persons possible."
  describe "A manual review is required to identify and restrict shared accounts." do
    skip 'A manual review is required to identify and restrict shared accounts.'
  end
end
