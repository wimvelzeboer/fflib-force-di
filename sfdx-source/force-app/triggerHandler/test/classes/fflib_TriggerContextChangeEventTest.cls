/**
 * File Name: fflib_TriggerContextChangeEventTest 
 * Description: Unit test class for fflib_TriggerContextChangeEvent
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
private class fflib_TriggerContextChangeEventTest
{
	@IsTest
	static void testBehavior()
	{
	}


	private class TestAccounts extends fflib_SObjectDomain
	{
		public TestAccounts(List<SObject> records, Schema.SObjectType sObjectType)
		{
			super(records, sObjectType);
		}
	}
}