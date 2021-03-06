control 'V-67871' do
  title "SQL Server must use NIST FIPS 140-2 validated cryptographic modules
  for cryptographic operations."
  desc "Use of weak or not validated cryptographic algorithms undermines the
  purposes of utilizing encryption and digital signatures to protect data.  Weak
  algorithms can be easily broken and not validated cryptographic modules may not
  implement algorithms correctly. Unapproved cryptographic modules or algorithms
  should not be relied on for authentication, confidentiality or integrity. Weak
  cryptography could allow an attacker to gain access to and modify data stored
  in the database as well as the administration settings of SQL Server.

      Applications, including DBMSs, utilizing cryptography are required to use
  approved NIST FIPS 140-2 validated cryptographic modules that meet the
  requirements of applicable federal laws, Executive Orders, directives,
  policies, regulations, standards, and guidance.

      Operations that require the use of cryptography include the provisioning of
  digital signatures, the generation and validation of cryptographic hashes, and
  the protection of data by storing and transmitting it in encrypted form.

      The security functions validated as part of FIPS 140-2 for cryptographic
  modules are described in FIPS 140-2 Annex A.

      SQL Server complies with FIPS 140-2 if Windows is configured to do so.

      NSA Type-X (where X=1, 2, 3, 4) products are NSA-certified, hardware-based
  encryption modules.
  "
  impact 0.7
  tag "gtitle": 'SRG-APP-000179-DB-000114'
  tag "gid": 'V-67871'
  tag "rid": 'SV-82361r1_rule'
  tag "stig_id": 'SQL4-00-031100'
  tag "fix_id": 'F-73987r1_fix'
  tag "cci": ['CCI-000803', 'CCI-002450']
  tag "nist": ['IA-7', 'SC-13', 'Rev_4']
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
  tag "check": "In Windows, open Administrative Tools >> Local Security Policy.
   Expand  Local Policies >> Security Options.  In the right-side pane, find
  \"System cryptography: Use FIPS compliant algorithms for encryption, hashing,
  and signing\".

  If, in the Security Setting column, the value is \"Disabled,\" this is a
  finding."
  tag "fix": "In Windows, open Administrative Tools >> Local Security Policy.
  Expand  Local Policies >> Security Options.  In the right-side pane,
  double-click on \"System cryptography: Use FIPS compliant algorithms for
  encryption, hashing, and signing\".

  In the dialog box that appears, if the radio buttons are active, click Enabled,
  and then click Apply.  If the radio buttons are grayed out, use Group Policy
  Management (on the appropriate server for this domain) to enforce the Enabled
  policy, and deploy it to the server(s) running SQL Server."
  describe registry_key('HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\FIPSAlgorithmPolicy') do
    it { should have_property 'Enabled' }
    its('Enabled') { should cmp == 1 }
  end
end
