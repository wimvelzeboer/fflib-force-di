/**
 * File Name: AccountsImpTest 
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com
 */
@IsTest
private class AccountsImpTest
{
	@IsTest
	static void itShouldSetTheSharing()
	{
		// GIVEN a instance of the AccountsImp with a number of records with different rating
		AccountsImp domain = new AccountsImp(
				new List<Account>
				{
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Rating = 'Cold'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Rating = 'Warm'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Rating = 'Hot'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Rating = ''),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
				}
		);

		// WHEN we set the rating to 'Hot'
		System.Test.startTest();
		domain.setRating('Hot');
		System.Test.stopTest();

		// THEN all records should have a 'Hot' rating
		System.assertEquals(5, domain.getRecords().size(), 'Incorrect number of records in the domain');
		for (SObject record : domain.getRecords())
		{
			System.assertEquals('Hot', record.get(Account.Rating), 'Record should have a Hot rating');
		}
	}

	@IsTest
	static void itShouldReturnOnlyRecordsWithDefinedShippingCountry()
	{
		// GIVEN a instance of the AccountsImp with a number of records with different shipping countries
		Id ukId = fflib_IDGenerator.generate(Account.SObjectType);
		Id ie1Id = fflib_IDGenerator.generate(Account.SObjectType);
		Id ie2Id = fflib_IDGenerator.generate(Account.SObjectType);
		AccountsImp domain = new AccountsImp(
				new List<Account>
				{
						new Account(Id = ie1Id, ShippingCountry = 'Ireland'),
						new Account(Id = ukId, ShippingCountry = 'United Kingdom'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), ShippingCountry = 'France'),
						new Account(Id = ie2Id, ShippingCountry = 'Ireland'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
				}
		);

		// WHEN we get all the records for 'Ireland' and 'United Kingdom'
		System.Test.startTest();
		List<Account> result = domain.getRecordsWithShippingCountries(
				new Set<String>
				{
						'Ireland',
						'United Kingdom'
				}
		);
		System.Test.stopTest();

		// THEN it should only return those records with the shipping country set to 'Ireland'
		System.assertEquals(
				new Set<Id>{ ie1Id, ukId, ie2Id},
				new Map<Id, SObject>(result).keySet(),
				'Incorrect records returned, just only wanted UK and IE records'
		);
	}
}