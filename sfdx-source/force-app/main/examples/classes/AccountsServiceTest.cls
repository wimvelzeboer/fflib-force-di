/**
 * File Name: AccountsServiceTest 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
private with sharing class AccountsServiceTest
{
	@IsTest
	static void itShouldCallTheDomainForTheCountiesAndUpdateTheRating()
	{
		// Given A cold South Africa account
		List<Account> records = new List<Account>
		{
				generateWarmCountry('South Africa')
		};
		List<Account> result = records.deepClone(true);
		result.get(0).Rating = 'Hot';

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		Accounts domainMock = (Accounts) mocks.mock(Accounts.class);
		fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		mocks.startStubbing();
		mocks.when(domainMock.sObjectType()).thenReturn(Account.SObjectType);
		mocks.when(domainMock.getRecordsWithShippingCountries(AccountsServiceImp.COLD_COUNTRIES)).thenReturn(new List<Account>());
		mocks.when(domainMock.getRecordsWithShippingCountries(AccountsServiceImp.HOT_COUNTRIES)).thenReturn(records);
		mocks.when(domainMock.getRecords()).thenReturn(result);
		mocks.when(domainMock.setRating('Hot')).thenReturn(domainMock);
		mocks.stopStubbing();

		Application.Domain.setMock(Account.SObjectType, domainMock);
		Application.UnitOfWork.setMock(unitOfWorkMock);

		// WHEN we update the rating
		AccountsService service = (AccountsService) Application.Service.newInstance(AccountsService.class);
		service.updateRating(domainMock);

		// THEN the rating should be changed into
		((Accounts)	mocks.verify(domainMock, 1)).getRecords();  // Should only get the records for the Cold
		((Accounts)	mocks.verify(domainMock, 1)).getRecordsWithShippingCountries(AccountsServiceImp.COLD_COUNTRIES);
		((Accounts)	mocks.verify(domainMock, 1)).getRecordsWithShippingCountries(AccountsServiceImp.HOT_COUNTRIES);
		((Accounts)	mocks.verify(domainMock, 0)).setRating('Cold');
		((Accounts)	mocks.verify(domainMock, 1)).setRating('Hot');
		((fflib_ISObjectUnitOfWork) mocks.verify(unitOfWorkMock, 1)).registerDirty(result);
	}

	private static Account generateWarmCountry(String countryName)
	{
		Account coldRecord = new Account(
				Id = fflib_IDGenerator.generate(Account.SObjectType),
				ShippingCountry = countryName,
				Rating = 'Warm');
		return coldRecord;
	}
}