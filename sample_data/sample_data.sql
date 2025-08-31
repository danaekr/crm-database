-- Insert sample users first (required for foreign keys)
INSERT INTO users (user_id, username, email, first_name, last_name, role, department, is_active) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'admin', 'admin@company.com', 'System', 'Administrator', 'Admin', 'IT', TRUE),
('550e8400-e29b-41d4-a716-446655440001', 'john.sales', 'john.smith@company.com', 'John', 'Smith', 'Sales Rep', 'Sales', TRUE),
('550e8400-e29b-41d4-a716-446655440002', 'mary.manager', 'mary.johnson@company.com', 'Mary', 'Johnson', 'Account Manager', 'Sales', TRUE),
('550e8400-e29b-41d4-a716-446655440003', 'mike.support', 'mike.brown@company.com', 'Mike', 'Brown', 'Support Agent', 'Support', TRUE),
('550e8400-e29b-41d4-a716-446655440004', 'lisa.sales', 'lisa.davis@company.com', 'Lisa', 'Davis', 'Sales Rep', 'Sales', TRUE);


-- Insert sample customers
INSERT INTO customers (customer_id, erp_customer_id, company_name, customer_type, industry, primary_email, primary_phone, 
                      billing_city, billing_country, customer_status, assigned_sales_rep, assigned_account_manager, created_by) VALUES
('650e8400-e29b-41d4-a716-446655440000', 'ERP-CUST-001', 'Acme Corporation', 'B2B', 'Manufacturing', 'contact@acme.com', '+1-555-0101', 'New York', 'USA', 'Active', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000'),
('650e8400-e29b-41d4-a716-446655440001', 'ERP-CUST-002', 'TechStart Inc', 'SME', 'Technology', 'info@techstart.com', '+1-555-0102', 'San Francisco', 'USA', 'Active', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000'),
('650e8400-e29b-41d4-a716-446655440002', 'ERP-CUST-003', 'Global Retail Ltd', 'Enterprise', 'Retail', 'procurement@globalretail.com', '+1-555-0103', 'Chicago', 'USA', 'Active', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000'),
('650e8400-e29b-41d4-a716-446655440003', 'ERP-CUST-004', 'Healthcare Plus', 'B2B', 'Healthcare', 'admin@healthcareplus.com', '+1-555-0104', 'Boston', 'USA', 'Prospect', '550e8400-e29b-41d4-a716-446655440004', NULL, '550e8400-e29b-41d4-a716-446655440000');

-- Insert sample contacts
INSERT INTO contacts (contact_id, customer_id, first_name, last_name, title, email, direct_phone, is_primary_contact, role) VALUES
('750e8400-e29b-41d4-a716-446655440000', '650e8400-e29b-41d4-a716-446655440000', 'Robert', 'Johnson', 'CTO', 'robert.johnson@acme.com', '+1-555-0201', TRUE, 'Decision Maker'),
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440000', 'Sarah', 'Wilson', 'IT Manager', 'sarah.wilson@acme.com', '+1-555-0202', FALSE, 'Technical'),
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 'David', 'Chen', 'CEO', 'david.chen@techstart.com', '+1-555-0203', TRUE, 'Decision Maker'),
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440002', 'Jennifer', 'Martinez', 'Procurement Manager', 'jennifer.martinez@globalretail.com', '+1-555-0204', TRUE, 'Financial'),
('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440003', 'Dr. Michael', 'Anderson', 'Chief Medical Officer', 'michael.anderson@healthcareplus.com', '+1-555-0205', TRUE, 'Decision Maker');

-- Insert sample services
INSERT INTO services (service_id, erp_service_id, service_code, service_name, service_category, base_price, billing_frequency, is_active) VALUES
('850e8400-e29b-41d4-a716-446655440000', 'ERP-SVC-001', 'CRM-BASIC', 'CRM Basic Package', 'Software', 99.00, 'Monthly', TRUE),
('850e8400-e29b-41d4-a716-446655440001', 'ERP-SVC-002', 'CRM-PRO', 'CRM Professional Package', 'Software', 199.00, 'Monthly', TRUE),
('850e8400-e29b-41d4-a716-446655440002', 'ERP-SVC-003', 'CRM-ENT', 'CRM Enterprise Package', 'Software', 499.00, 'Monthly', TRUE),
('850e8400-e29b-41d4-a716-446655440003', 'ERP-SVC-004', 'SUPPORT-PREMIUM', 'Premium Support', 'Support', 149.00, 'Monthly', TRUE),
('850e8400-e29b-41d4-a716-446655440004', 'ERP-SVC-005', 'TRAINING-BASIC', 'Basic Training Package', 'Training', 299.00, 'One-time', TRUE);

-- Insert sample opportunities
INSERT INTO opportunities (opportunity_id, customer_id, opportunity_name, opportunity_type, estimated_value, 
                          probability, expected_close_date, stage, status, owner_id, created_by) VALUES
('950e8400-e29b-41d4-a716-446655440000', '650e8400-e29b-41d4-a716-446655440000', 'Acme CRM Upgrade', 'Upsell', 15000.00, 0.75, '2025-09-15', 'Proposal', 'Open', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001'),
('950e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 'TechStart New Implementation', 'New Business', 8000.00, 0.60, '2025-09-30', 'Negotiation', 'Open', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004'),
('950e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', 'Global Retail Enterprise Deal', 'New Business', 50000.00, 0.85, '2025-10-15', 'Negotiation', 'Open', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001'),
('950e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', 'Healthcare Plus Initial Setup', 'New Business', 12000.00, 0.40, '2025-11-01', 'Qualification', 'Open', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440004');

-- Insert opportunity line items
INSERT INTO opportunity_line_items (opportunity_id, service_id, quantity, unit_price, discount_percent, proposed_start_date, contract_duration_months) VALUES
('950e8400-e29b-41d4-a716-446655440000', '850e8400-e29b-41d4-a716-446655440002', 1, 499.00, 10.00, '2025-09-01', 24),
('950e8400-e29b-41d4-a716-446655440000', '850e8400-e29b-41d4-a716-446655440003', 1, 149.00, 0.00, '2025-09-01', 24),
('950e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440001', 1, 199.00, 5.00, '2025-10-01', 12),
('950e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440002', 5, 499.00, 15.00, '2025-10-15', 36),
('950e8400-e29b-41d4-a716-446655440003', '850e8400-e29b-41d4-a716-446655440000', 1, 99.00, 0.00, '2025-11-01', 12);

-- Insert sample customer services (active subscriptions)
INSERT INTO customer_services (subscription_id, customer_id, service_id, erp_subscription_id, subscription_name,
                              quantity, unit_price, service_status, activation_date, contract_start_date, 
                              contract_end_date, sales_opportunity_id) VALUES
('A50e8400-e29b-41d4-a716-446655440000', '650e8400-e29b-41d4-a716-446655440000', '850e8400-e29b-41d4-a716-446655440001', 'ERP-SUB-001', 'Acme CRM Pro Subscription', 1, 199.00, 'Active', '2024-01-15', '2024-01-15', '2025-01-14', NULL),
('A50e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '850e8400-e29b-41d4-a716-446655440000', 'ERP-SUB-002', 'TechStart CRM Basic', 1, 99.00, 'Active', '2024-06-01', '2024-06-01', '2025-05-31', NULL),
('A50e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '850e8400-e29b-41d4-a716-446655440002', 'ERP-SUB-003', 'Global Retail Enterprise CRM', 3, 499.00, 'Active', '2023-09-01', '2023-09-01', '2025-08-31', NULL);


-- Insert sample interactions
INSERT INTO interactions (interaction_id, customer_id, contact_id, opportunity_id, interaction_type, subject, 
                         description, interaction_date, duration_minutes, performed_by) VALUES
('B50e8400-e29b-41d4-a716-446655440000', '650e8400-e29b-41d4-a716-446655440000', '750e8400-e29b-41d4-a716-446655440000', '950e8400-e29b-41d4-a716-446655440000', 'Call', 'Initial Discovery Call', 'Discussed current CRM usage and upgrade requirements', '2025-08-15 10:00:00', 45, '550e8400-e29b-41d4-a716-446655440001'),
('B50e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440002', '950e8400-e29b-41d4-a716-446655440001', 'Meeting', 'Product Demo', 'Demonstrated CRM Pro features and integration capabilities', '2025-08-20 14:00:00', 90, '550e8400-e29b-41d4-a716-446655440004'),
('B50e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440003', '950e8400-e29b-41d4-a716-446655440002', 'Email', 'Follow-up on Enterprise Proposal', 'Sent detailed proposal with custom pricing for enterprise package', '2025-08-25 09:30:00', NULL, '550e8400-e29b-41d4-a716-446655440001'),
('B50e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440000', '750e8400-e29b-41d4-a716-446655440001', NULL, 'Support', 'Technical Support Call', 'Resolved integration issue with current CRM system', '2025-08-28 11:15:00', 30, '550e8400-e29b-41d4-a716-446655440003');

-- Insert sample support tickets
INSERT INTO support_tickets (ticket_id, customer_id, contact_id, subscription_id, title, description, 
                            category, priority, status, assigned_to) VALUES
('C50e8400-e29b-41d4-a716-446655440000', '650e8400-e29b-41d4-a716-446655440000', '750e8400-e29b-41d4-a716-446655440001', 'A50e8400-e29b-41d4-a716-446655440000', 'Login Issues', 'Users unable to login after recent update', 'Technical', 'High', 'In Progress', '550e8400-e29b-41d4-a716-446655440003'),
('C50e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440002', 'A50e8400-e29b-41d4-a716-446655440001', 'Feature Request', 'Request for custom report functionality', 'Feature Request', 'Medium', 'Open', '550e8400-e29b-41d4-a716-446655440003'),
('C50e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440003', 'A50e8400-e29b-41d4-a716-446655440002', 'Performance Issue', 'System running slowly during peak hours', 'Performance', 'High', 'Resolved', '550e8400-e29b-41d4-a716-446655440003');

-- Insert some ERP sync log entries
INSERT INTO erp_sync_log (entity_type, entity_id, crm_entity_id, sync_operation, sync_status, sync_direction) VALUES
('Customer', 'ERP-CUST-001', '650e8400-e29b-41d4-a716-446655440000', 'UPDATE', 'SUCCESS', 'ERP_TO_CRM'),
('Customer', 'ERP-CUST-002', '650e8400-e29b-41d4-a716-446655440001', 'UPDATE', 'SUCCESS', 'ERP_TO_CRM'),
('Subscription', 'ERP-SUB-001', 'A50e8400-e29b-41d4-a716-446655440000', 'UPDATE', 'SUCCESS', 'ERP_TO_CRM'),
('Service', 'ERP-SVC-001', '850e8400-e29b-41d4-a716-446655440000', 'CREATE', 'SUCCESS', 'ERP_TO_CRM');

-- Insert ERP entity mappings
INSERT INTO erp_entity_mapping (erp_entity_type, erp_entity_id, crm_entity_type, crm_entity_id, mapping_status) VALUES
('customer', 'ERP-CUST-001', 'customer', '650e8400-e29b-41d4-a716-446655440000', 'Active'),
('customer', 'ERP-CUST-002', 'customer', '650e8400-e29b-41d4-a716-446655440001', 'Active'),
('customer', 'ERP-CUST-003', 'customer', '650e8400-e29b-41d4-a716-446655440002', 'Active'),
('service', 'ERP-SVC-001', 'service', '850e8400-e29b-41d4-a716-446655440000', 'Active'),
('service', 'ERP-SVC-002', 'service', '850e8400-e29b-41d4-a716-446655440001', 'Active'),
('subscription', 'ERP-SUB-001', 'customer_service', 'A50e8400-e29b-41d4-a716-446655440000', 'Active'),
('subscription', 'ERP-SUB-002', 'customer_service', 'A50e8400-e29b-41d4-a716-446655440001', 'Active');
