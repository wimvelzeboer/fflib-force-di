/**
 * File Name: fflib_TriggerHandlerImp
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public virtual with sharing class fflib_TriggerHandlerImp implements fflib_TriggerHandler
{
	protected String appName;
	protected fflib_DomainFactory domainFactory;

	public fflib_TriggerHandlerImp(String appName, fflib_DomainFactory domainFactory)
	{
		this.appName = appName;
		this.domainFactory = domainFactory;
	}

	public void handle(Schema.SObjectType sObjectType)
	{
		handle(generateNewTriggerContext(sObjectType));
	}

	public void handle(fflib_TriggerContext ctx)
	{
		Objects handlers =
				getBindings(ctx.getSObjectType())
						.newInstances()
						.filter(new TriggerHandlerObjectFilter());

		if (handlers.isEmpty()) return;

		ctx.setDomainFactory(domainFactory);

		new TriggerHandlers(
				handlers.get(),
				ctx
		)
				.preSteps()
				// todo - call handle method of ctx
				.execute();
	}

	private di_Bindings getBindings(SObjectType sObjectType)
	{
		return new di_Bindings(di_Injector.Org.Bindings.bySObject(sObjectType).get());
	}

	private List<fflib_TriggerAction> newTriggerHandlerInstancesForBinding(List<di_Binding> bindings)
	{
		List<fflib_TriggerAction> result = new List<fflib_TriggerAction>();
		for (di_Binding binding : bindings)
		{
			Object handler = binding.getInstance();
			if (handler instanceof fflib_TriggerAction)
			{
				result.add((fflib_TriggerAction) handler);
			}
			else
			{
				throw new TriggerHandlerFactoryException('Binding for ' + binding.DeveloperName + ' must extend fflib_TriggerHandler');
			}
		}
		return result;
	}

	public void replaceWith(SObjectType sObjectType, Type handlerInterfaceType, Object triggerHandlerImpl)
	{
		di_Injector.Org.Bindings
				.byName(getBindingName(sObjectType))
				.byName(handlerInterfaceType.getName())
				.replaceBindingWith(triggerHandlerImpl);
	}

	private fflib_TriggerContext generateNewTriggerContext(Schema.SObjectType sObjectType)
	{
		String sObjectName = sObjectType.getDescribe().getName();
		if (sObjectName.endsWith('__e'))
		{
			return (fflib_TriggerContext) new fflib_TriggerContextPlatformEvent(sObjectType);
		}
		else if (sObjectName.endsWith('__ChangeEvent'))
		{
			return (fflib_TriggerContext) new fflib_TriggerContextChangeEvent(sObjectType);
		}
		return (fflib_TriggerContext) new fflib_TriggerContextSObject(sObjectType);
	}

	private String getBindingName(Schema.SObjectType sObjectType)
	{
		return this.appName + '.triggerhandler.' + sObjectType.getDescribe().getName();
	}

	public class TriggerHandlerFactoryException extends Exception
	{
	}

	private class TriggerHandlerObjectFilter implements Objects.FilterVisitor
	{
		public Boolean validate(Object obj)
		{
			if (!(obj instanceof fflib_TriggerAction))
			{
				throw new TriggerHandlerFactoryException('Binding must extend from fflib_TriggerHandler');
			}
			return true;
		}
	}

	private class TriggerHandlers
	{
		private List<fflib_TriggerAction> items;
		private fflib_TriggerContext ctx;

		private TriggerHandlers(List<Object> triggerHandlers, fflib_TriggerContext ctx)
		{
			this.items = new List<fflib_TriggerAction>();
			for (Object obj : triggerHandlers)
			{
				if (obj instanceof fflib_TriggerAction)
				{
					this.items.add((fflib_TriggerAction) obj );
				} else {
					throw new TriggerHandlerFactoryException('Oops');
				}
			}
			this.ctx = ctx;
		}

		private TriggerHandlers(List<fflib_TriggerAction> triggerHandlers, fflib_TriggerContext ctx)
		{
			this.items = triggerHandlers;
			this.ctx = ctx;
		}

		private TriggerHandlers execute()
		{
			System.debug('Execute Steps');
			for (fflib_TriggerAction handler : this.items)
			{
				handler.run(this.ctx);
			}
			return this;
		}

		private TriggerHandlers preSteps()
		{
			System.debug('Pre Steps');
			for (fflib_TriggerAction handler : this.items)
			{
				handler.pre(this.ctx);
			}
			return this;
		}
	}
}