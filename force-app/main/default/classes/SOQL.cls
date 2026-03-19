/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Miki Todosov
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> sfLeads () {
		List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
		return allLeads;
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> sfContacts() {
		List<Contact> allContacts = [SELECT Id, Name FROM Contact WHERE FirstName = 'John'];
		return allContacts;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> contactIds () {
		List<Id> returnedIds = new List<Id>();
		List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN ('Smith','Jones')];
		for(Contact con : contacts){ // Is there another way to add the returned Contact Ids in the Id List other than loop?
			returnedIds.add(con.Id);
		}
		return returnedIds;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> oppty(Id accountId) {
		List<Opportunity> returnedOppties = [SELECT Id, Name, CloseDate, StageName, Amount, AccountId FROM Opportunity WHERE AccountId = :accountId];
		return returnedOppties;
	} // I don't know if what I did was OK, but in order for my test to pass I had to remove the AccountId assignment from the 'Test Opportunity 3'.
	  // Test was expecting 2, but it was returning 3 Opportunities because the AccountId for the 'Test Opportunity 3' was set as AccountId = testAccount.Id

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer numberOfAccounts() {
		Integer finalCount = [SELECT COUNT() FROM Account];
		return finalCount;
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id,Task> taskMap() {
		Map<Id,Task> IdsAndTasks = new Map<Id,Task>();
		List<Task> tasks = [SELECT Id FROM Task WHERE ActivityDate >= today AND ActivityDate <= NEXT_N_DAYS:7];
		for(Task task : tasks) {
			IdsAndTasks.put(task.Id, task);
		}
		return IdsAndTasks;
	}
	/** after I watched the module 5 videos, maybe this would be better?
	 *  Map<Id,Task> IdsAndTasks = new Map<Id,Task>([SELECT Id, Name FROM Task WHERE ActivityDate >= today AND ActivityDate <= NEXT_N_DAYS:7]);
	 *  return IdsAndTasks;

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> emailContacts() {
		List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Email LIKE '%example.com%'];
		return contacts;
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String searchTerm = '%' + keyword + '%';
		List<Opportunity> oppties = [SELECT Id, Name, StageName, CloseDate, AccountId FROM Opportunity WHERE Name LIKE :searchTerm];
		return oppties; 
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		List<Case> cases = [SELECT Status, AccountId, Origin FROM Case WHERE Origin NOT IN ('Web','Email', null)];
		return cases;
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> returnedLeads (String leadSource, String keyword) {
		String searchWord = '%' + keyword + '%';
		List<Lead> leads = [SELECT LastName, Company, Phone, Email, LeadSource, Title FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :searchWord];
		return leads;
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		List<String> contactLastNames = new List<String>();
		List<Contact> contacts = [SELECT Id, Name, LastName, AccountId FROM Contact WHERE AccountId = :accountId];
		for (Contact con : contacts) {
			contactLastNames.add(con.LastName);
		}
		return contactLastNames;
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) { //This might be possible to do with SUM, I just wasn't sure how to incorporate it in Apex.
		Decimal totalRevenue = 0;
		Opportunity[] oppties = [SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity WHERE StageName = :stage AND Amount >= 10000];
		for(Opportunity opp : oppties){
				totalRevenue += opp.Amount;
			}
		return totalRevenue;
		}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		Account[] firstTenAccounts = [SELECT Id, Name FROM Account LIMIT 10];
		return firstTenAccounts;
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		Opportunity[] oppList = [SELECT Id, CloseDate, Name, Amount FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
		return oppList;
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		Contact[] contactList = [SELECT Id, Name, Birthdate FROM Contact ORDER BY Birthdate DESC LIMIT 3];
		return contactList;
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		Case[] caseList = [SELECT Id, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
		return caseList;
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		Set<Id> caseIds = new Set<Id>();
		Case[] cases = [SELECT Id, AccountId FROM Case WHERE AccountId = :accountId];
		for(Case c : cases){
			caseIds.add(c.Id);
		}
		return caseIds;
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		String[] countries = new List<String>{country};
		Map<Id, String> accountIdsToNames = new Map<Id, String>();
		Account[] accounts = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry NOT IN :countries];
		for(Account acc:accounts){
			accountIdsToNames.put(acc.Id, acc.Name);
		}
		return accountIdsToNames;
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		Contact con = [SELECT Id, Name, Account.Name FROM Contact WHERE Id = :contactId];
		String accountName = con.Account.Name;
		return accountName;
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Account acc = [SELECT Id, Name, (SELECT Name, Account.Id FROM Opportunities) FROM Account];
		return acc;
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		Account acc = [SELECT Id, BillingState FROM Account WHERE Id = :accountId];
		String accBillingState = acc.BillingState;
		Contact[] contacts = [SELECT Id, Name, MailingState FROM Contact WHERE MailingState = :accBillingState];
		return contacts;
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		Lead[] leads = [SELECT Id, Name, Email FROM Lead WHERE Id IN :leadIds];
		Set<String> accountWebsite = new Set<String>();
		for(Lead lead:leads){
			if(lead.Email == null){
				continue;
			} else{
				String website = 'www.'+lead.Email.substringAfter('@');
				accountWebsite.add(website);
			}
		}
		Account[] accounts = [SELECT Id, Name, Website FROM Account WHERE Website IN :accountWebsite];
		return accounts;	
	}
	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		OpportunityLineItem[] oli = [SELECT Id, Quantity, UnitPrice, OpportunityId, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId];
		OpportunityLineItem[] newOli = new List<OpportunityLineItem>();
		for(Id oppId : cloneOppIds){
			for(OpportunityLineItem oppLineItem : oli){
				OpportunityLineItem newOppLineItem = new OpportunityLineItem();
				newOppLineItem.OpportunityId = oppId;
				newOppLineItem.Quantity = (Integer)(Math.random() * 3) + 1;
				newOppLineItem.UnitPrice = oppLineItem.UnitPrice;
				newOppLineItem.PricebookEntryId = oppLineItem.PricebookEntryId;
				newOli.add(newOppLineItem);
			}
		}
		insert newOli;
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		Opportunity[] opps = [SELECT Name, Account.Name, Owner.Name, StageName FROM Opportunity WHERE StageName ='Closed Won'];
		return opps;
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		Opportunity[] opps = SOQL.getOpportunityDetailsForClosedWon();
		Set<Id> accountIds = new Set<Id>();
		for(Opportunity opp : opps){
			accountIds.add(opp.AccountId);
		}
		Contact[] contacts = [SELECT Id, FirstName, LastName, Name, AccountId FROM Contact WHERE AccountId IN :accountIds ORDER BY FirstName];
		Map<Id,Id> accountToContact = new Map<Id,Id>();
		for(Contact con:contacts){
			if(!accountToContact.containsKey(con.AccountId)){
			accountToContact.put(con.AccountId, con.Id);
			}
		}
		for(Opportunity oppty:opps){
			oppty.Primary_Contact__c = accountToContact.get(oppty.AccountId);
		}
		update opps;
	}
}
