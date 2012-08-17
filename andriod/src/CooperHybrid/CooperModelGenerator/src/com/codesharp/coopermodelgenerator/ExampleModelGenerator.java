package com.codesharp.coopermodelgenerator;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Property;
import de.greenrobot.daogenerator.Schema;
import de.greenrobot.daogenerator.ToMany;

public class ExampleModelGenerator {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
        Schema schema = new Schema(3, "com.codesharp.cooper");

        addTasklist(schema);
        addTask(schema);
        addTaskIdx(schema);
        addChangeLog(schema);

        new DaoGenerator().generateAll(schema, "../src-gen");
    }
	
	private static void addTasklist(Schema schema) {
		Entity tasklist = schema.addEntity("Tasklist");
		tasklist.addIdProperty().autoincrement();
		tasklist.addStringProperty("accountId");
		tasklist.addDateProperty("createTime");
		tasklist.addBooleanProperty("editable");
		tasklist.addStringProperty("extensions");
		tasklist.addStringProperty("tasklistId");
		tasklist.addStringProperty("listType");
		tasklist.addStringProperty("name");
	}
	
	private static void addTask(Schema schema) {
		Entity task = schema.addEntity("Task");
		task.addIdProperty().autoincrement();
		task.addStringProperty("accountId");
		task.addStringProperty("body");
		task.addDateProperty("createDate");
		task.addDateProperty("dueDate");
		task.addStringProperty("taskId");
		task.addBooleanProperty("isPublic");
		task.addDateProperty("lastUpdateDate");
		task.addStringProperty("priority");
		task.addIntProperty("status");
		task.addBooleanProperty("editable");
		task.addStringProperty("subject");
		task.addStringProperty("tasklistId");
	}
	
	private static void addTaskIdx(Schema schema) {
		Entity taskIdx = schema.addEntity("TaskIdx");
		taskIdx.addIdProperty().autoincrement();
		taskIdx.addStringProperty("accountId");
		taskIdx.addStringProperty("by");
		taskIdx.addStringProperty("indexes");
		taskIdx.addStringProperty("key");
		taskIdx.addStringProperty("name");
		taskIdx.addStringProperty("tasklistId");
	}
	
	private static void addChangeLog(Schema schema) {
		Entity changeLog = schema.addEntity("ChangeLog");
		changeLog.addIdProperty().autoincrement();
		changeLog.addStringProperty("accountId");
		changeLog.addStringProperty("changeType");
		changeLog.addStringProperty("dataid");
		changeLog.addBooleanProperty("isSend");
		changeLog.addStringProperty("name");
		changeLog.addStringProperty("tasklistId");
		changeLog.addStringProperty("value");
	}

//	private static void addNote(Schema schema) {
//        Entity note = schema.addEntity("Note");
//        note.addIdProperty();
//        note.addStringProperty("text").notNull();
//        note.addStringProperty("comment");
//        note.addDateProperty("date");
//    }
//
//    private static void addCustomerOrder(Schema schema) {
//        Entity customer = schema.addEntity("Customer");
//        customer.addIdProperty();
//        customer.addStringProperty("name").notNull();
//
//        Entity order = schema.addEntity("Order");
//        order.setTableName("ORDERS"); // "ORDER" is a reserved keyword
//        order.addIdProperty();
//        Property orderDate = order.addDateProperty("date").getProperty();
//        Property customerId = order.addLongProperty("customerId").notNull().getProperty();
//        order.addToOne(customer, customerId);
//
//        ToMany customerToOrders = customer.addToMany(order, customerId);
//        customerToOrders.setName("orders");
//        customerToOrders.orderAsc(orderDate);
//    }
}
