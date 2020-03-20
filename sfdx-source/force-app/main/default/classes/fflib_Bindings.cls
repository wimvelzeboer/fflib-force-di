/**
 * File Name: fflib_Bindings
 * Description: Domain class for fflib_Binding_mdt
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
public with sharing class fflib_Bindings extends fflib_SObjectDomain
{

	private static final String SELECTOR = 'Selector';
	private static final String DOMAIN = 'Domain';
	private static final String APEX = 'Apex';

	private static final String BINDING_DIVIDER = '.';

	private static final Map<String, Type> BINDING_TYPE_IMP_BY_NAME = new Map<String, Type>
	{
			'Domain' => fflib_Bindings.DomainBinding.class,
			'Service' => fflib_Bindings.ServiceBinding.class,
			'Selector' => fflib_Bindings.SelectorBinding.class,
			'Other' => fflib_Bindings.ApexBinding.class
	};

	public fflib_Bindings(List<fflib_Binding__mdt> records)
	{
		super(records);
	}

	/**
	 * getBindings
	 *
	 * @description Every binding type will have its own instance of Binding to be able to return binding specific values
	 * @return List of Bindings
	 */
	public List<Binding> getBindings()
	{
		List<Binding> result = new List<Binding>();
		for (fflib_Binding__mdt record : (List<fflib_Binding__mdt>) Records)
		{
			String bindingType = String.valueOf(record.get(fflib_Binding__mdt.Type__c));
			if (!BINDING_TYPE_IMP_BY_NAME.containsKey(bindingType))
			{
				// todo throw exception
			}

			fflib_Bindings.Binding binding =
					(fflib_Bindings.Binding) BINDING_TYPE_IMP_BY_NAME.get(bindingType).newInstance();
			binding.setRecord(record);
			result.add(binding);
		}
		return result;
	}


	/**
	 * Interface to set default methods for the Bindings
	 */
	public interface Binding
	{
		String getName();
		fflib_Binding__mdt getRecord();
		void setRecord(fflib_Binding__mdt record);
		Integer getSequence();
		String getTo();
	}


	/**
	 * Generic Apex Binding class
	 */
	public virtual with sharing class ApexBinding implements Binding
	{
		protected fflib_Binding__mdt record;

		public virtual String getName()
		{
			return getName(APEX);
		}

		public virtual fflib_Binding__mdt getRecord()
		{
			return record;
		}

		/**
		 * getSequence
		 *
		 * @description Get the stored sequence number for the binding, used in setting a certain ordering
		 * @return Returns Null if no sequence is set, otherwise returns its Integer value
		 */
		public virtual Integer getSequence()
		{
			if (record.BindingSequence__c == null)
			{
				return null;
			}

			return Integer.valueOf(record.BindingSequence__c);
		}

		/**
		 * getTo
		 *
		 * @description The "To" is name of the implementation class stored in the Binding
		 * @return The value of fflib_Binding__mdt.To__c
		 */
		public virtual String getTo()
		{
			return record.To__c;
		}

		/**
		 * setRecord
		 *
		 * @description Replace the SObject with a one
		 * @param record
		 */
		public void setRecord(fflib_Binding__mdt record)
		{
			this.record = record;
		}

		/**
		 * getName
		 *
		 * @description The binding name will be generated based on the namespace, it's type and SObjectType
		 * @param type
		 *
		 * @return Binding names used by force-di as key for the binding
		 */
		protected String getName(String type)
		{
			String str = (getAppOrNameSpaceName() + BINDING_DIVIDER + type + BINDING_DIVIDER + getSObjectName())
					.toLowerCase();
			return str;
		}

		/**
		 * getAppOrNameSpaceName
		 *
		 * @description Use the Namespace name if available, otherwise use the App name
		 * @return Returns either fflib_Binding__mdt.NamespacePrefix is available or NamespacePrefix.AppName__c
		 */
		protected String getAppOrNameSpaceName()
		{
			return (String.isNotBlank(record.NamespacePrefix) ?  record.NamespacePrefix : record.AppName__c);
		}

		/**
		 * getSObjectName
		 *
		 * @description Use the Binding object or if blank use the alternate
		 * @return Returns fflib_Binding__mdt.BindingObject__c if available or fflib_Binding__mdt.BindingObjectAlternate__c
		 */
		protected String getSObjectName()
		{
			return (String.isNotBlank(record.BindingObject__c) ?
					record.BindingObject__r.QualifiedApiName.toLowerCase().trim() :
					record.BindingObjectAlternate__c.toLowerCase().trim());
		}
	}

	/**
	 * Selector Binding
	 */
	public with sharing class SelectorBinding extends ApexBinding
	{
		public override String getName()
		{
			return getName(SELECTOR);
		}
	}

	public with sharing class DomainBinding extends ApexBinding
	{
		public override String getName()
		{
			return getName(DOMAIN);
		}

		public override String getTo()
		{
			return record.To__c.endsWith('Constructor') ? record.To__c : record.To__c + '.Constructor';
		}
	}

	public with sharing class ServiceBinding extends ApexBinding
	{
		public override String getName()
		{
			return record.DeveloperName;
		}
	}
}