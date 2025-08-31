-- main customer/account table
CREATE TABLE customers (
    customer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    erp_customer_id VARCHAR(50) UNIQUE NOT NULL, -- Reference to ERP system
    company_name VARCHAR(255) NOT NULL,
    legal_name VARCHAR(255),
    customer_type VARCHAR(20) CHECK (customer_type IN ('B2B', 'B2C', 'Enterprise', 'SME')) NOT NULL,
    industry VARCHAR(100),
    tax_id VARCHAR(50),
    registration_number VARCHAR(50),


    
    -- Contact Information
    primary_email VARCHAR(255) NOT NULL,
    primary_phone VARCHAR(20),
    website VARCHAR(255),
    
    -- Address Information
    billing_address_line1 VARCHAR(255),
    billing_address_line2 VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(100),
    billing_postal_code VARCHAR(20),
    billing_country VARCHAR(100),
    
    -- CRM Specific Fields
    customer_status VARCHAR(20) CHECK (customer_status IN ('Active', 'Inactive', 'Prospect', 'Suspended')) DEFAULT 'Prospect',
    credit_rating VARCHAR(20) CHECK (credit_rating IN ('Excellent', 'Good', 'Fair', 'Poor')) DEFAULT 'Good',
    payment_terms INTEGER DEFAULT 30, -- Days
    preferred_communication VARCHAR(20) CHECK (preferred_communication IN ('Email', 'Phone', 'SMS', 'Mail')) DEFAULT 'Email',

    
    -- Relationship Management
    assigned_sales_rep UUID,
    assigned_account_manager UUID,
    customer_segment VARCHAR(50),
    lifecycle_stage VARCHAR(20) CHECK (lifecycle_stage IN ('Lead', 'Prospect', 'Customer', 'At Risk', 'Churned')) DEFAULT 'Lead',
    
    -- Sync and Audit
    last_erp_sync TIMESTAMP,
    erp_sync_status VARCHAR(20) CHECK (erp_sync_status IN ('Synced', 'Pending', 'Error')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- Contact persons within customer organizations
CREATE TABLE contacts (
    contact_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    erp_contact_id VARCHAR(50), -- Optional reference to ERP
    
    -- Personal Information
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    title VARCHAR(100),
    department VARCHAR(100),
    role VARCHAR(20) CHECK (role IN ('Primary', 'Secondary', 'Technical', 'Financial', 'Decision Maker')) DEFAULT 'Secondary',
    
    -- Contact Details
    email VARCHAR(255),
    direct_phone VARCHAR(20),
    mobile_phone VARCHAR(20),
    extension VARCHAR(10),
    
    -- Preferences
    is_primary_contact BOOLEAN DEFAULT FALSE,
    preferred_communication VARCHAR(20) CHECK (preferred_communication IN ('Email', 'Phone', 'SMS')) DEFAULT 'Email',
    marketing_opt_in BOOLEAN DEFAULT TRUE,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- =============================================
-- SERVICE INTEGRATION WITH ERP


-- Service catalog (synced from ERP)
CREATE TABLE services (
    service_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    erp_service_id VARCHAR(50) UNIQUE NOT NULL, -- Master reference from ERP
    service_code VARCHAR(50) UNIQUE NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    service_category VARCHAR(100),
    description TEXT,
    
    -- Pricing (informational - ERP is master)
    base_price DECIMAL(15,2),
    currency_code VARCHAR(3) DEFAULT 'USD',
    billing_frequency VARCHAR(20) CHECK (billing_frequency IN ('Monthly', 'Quarterly', 'Annually', 'One-time')),
    
    -- Service Management
    is_active BOOLEAN DEFAULT TRUE,
    requires_provisioning BOOLEAN DEFAULT FALSE,
    service_level_tier VARCHAR(20) CHECK (service_level_tier IN ('Basic', 'Standard', 'Premium', 'Enterprise')),
    
    -- ERP Sync
    last_erp_sync TIMESTAMP,
    erp_sync_status VARCHAR(20) CHECK (erp_sync_status IN ('Synced', 'Pending', 'Error')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer service subscriptions (reflects ERP master data)
CREATE TABLE customer_services (
    subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id),
    service_id UUID NOT NULL REFERENCES services(service_id),
    erp_subscription_id VARCHAR(50) UNIQUE NOT NULL, -- Master reference from ERP
    
    -- Service Details
    subscription_name VARCHAR(255),
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(15,2),
    
    -- Service Status (synced from ERP)
    service_status VARCHAR(20) CHECK (service_status IN ('Active', 'Suspended', 'Terminated', 'Pending')) NOT NULL,
    activation_date DATE,
    suspension_date DATE,
    termination_date DATE,
    next_billing_date DATE,
    
    -- Contract Info
    contract_start_date DATE,
    contract_end_date DATE,
    auto_renewal BOOLEAN DEFAULT TRUE,
    cancellation_notice_days INTEGER DEFAULT 30,
    
    -- CRM Tracking
    sales_opportunity_id UUID, -- Link to opportunity that generated this
    renewal_probability DECIMAL(3,2) DEFAULT 0.85,
    churn_risk_score DECIMAL(3,2) DEFAULT 0.00,
    last_usage_review DATE,
    
    -- ERP Sync
    last_erp_sync TIMESTAMP,
    erp_sync_status VARCHAR(20) CHECK (erp_sync_status IN ('Synced', 'Pending', 'Error')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- SALES & OPPORTUNITY MANAGEMENT


-- Sales opportunities
CREATE TABLE opportunities (
    opportunity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id),
    opportunity_name VARCHAR(255) NOT NULL,
    
    -- Opportunity Details
    description TEXT,
    opportunity_type VARCHAR(20) CHECK (opportunity_type IN ('New Business', 'Upsell', 'Cross-sell', 'Renewal')) NOT NULL,
    lead_source VARCHAR(100),
    
    -- Financial Info
    estimated_value DECIMAL(15,2),
    probability DECIMAL(3,2) DEFAULT 0.50,
    expected_close_date DATE,
    actual_close_date DATE,
    
    -- Pipeline Management
    stage VARCHAR(20) CHECK (stage IN ('Qualification', 'Needs Analysis', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost')) DEFAULT 'Qualification',
    status VARCHAR(20) CHECK (status IN ('Open', 'Won', 'Lost')) DEFAULT 'Open',
    
    -- Assignment
    owner_id UUID NOT NULL, -- Sales rep
    created_by UUID,
    
    -- Tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Opportunity line items (services being proposed)
CREATE TABLE opportunity_line_items (
    line_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    opportunity_id UUID NOT NULL REFERENCES opportunities(opportunity_id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES services(service_id),
    
    -- Proposal Details
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(15,2),
    discount_percent DECIMAL(5,2) DEFAULT 0.00,
    total_price DECIMAL(15,2), -- Will be calculated via trigger or application logic
    
    -- Service Configuration
    proposed_start_date DATE,
    contract_duration_months INTEGER,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =======================================
-- CUSTOMER INTERACTION TRACKING


-- All customer interactions and communications
CREATE TABLE interactions (
    interaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(customer_id),
    contact_id UUID REFERENCES contacts(contact_id),
    opportunity_id UUID REFERENCES opportunities(opportunity_id),
    
    -- Interaction Details
    interaction_type VARCHAR(20) CHECK (interaction_type IN ('Call', 'Email', 'Meeting', 'Demo', 'Support', 'Marketing')) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    outcome TEXT,
    
    -- Scheduling
    interaction_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER,
    
    -- Follow-up
    follow_up_required BOOLEAN DEFAULT FALSE,
    follow_up_date DATE,
    follow_up_completed BOOLEAN DEFAULT FALSE,
    
    -- Assignment
    performed_by UUID NOT NULL, -- Staff member
    
    -- Tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- SUPPORT AND SERVICE MANAGEMENT


-- Customer support tickets
CREATE TABLE support_tickets (
    ticket_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id UUID NOT NULL REFERENCES customers(customer_id),
    contact_id UUID REFERENCES contacts(contact_id),
    subscription_id UUID REFERENCES customer_services(subscription_id),
    
    -- Ticket Details
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    priority VARCHAR(20) CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')) DEFAULT 'Medium',
    severity VARCHAR(20) CHECK (severity IN ('Minor', 'Major', 'Critical')) DEFAULT 'Minor',
    
    -- Status Management
    status VARCHAR(20) CHECK (status IN ('Open', 'In Progress', 'Pending Customer', 'Resolved', 'Closed')) DEFAULT 'Open',
    resolution_summary TEXT,
    
    -- Assignment
    assigned_to UUID, -- Support agent
    escalated_to UUID, -- Manager if escalated
    
    -- Timing
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    first_response_at TIMESTAMP,
    resolved_at TIMESTAMP,
    closed_at TIMESTAMP,
    
    -- SLA Tracking
    sla_due_date TIMESTAMP,
    sla_breached BOOLEAN DEFAULT FALSE
);

-- =============================================
-- SYSTEM USERS AND ROLES


-- CRM system users
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    
    -- Role and Department
    role VARCHAR(20) CHECK (role IN ('Sales Rep', 'Account Manager', 'Sales Manager', 'Support Agent', 'Support Manager', 'Admin')) NOT NULL,
    department VARCHAR(100),
    manager_id UUID REFERENCES users(user_id),
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    
    -- Tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- ERP INTEGRATION TABLES


-- ERP sync log for tracking data synchronization
CREATE TABLE erp_sync_log (
    sync_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(20) CHECK (entity_type IN ('Customer', 'Service', 'Subscription', 'Contact')) NOT NULL,
    entity_id VARCHAR(50) NOT NULL, -- ERP ID being synced
    crm_entity_id UUID, -- Corresponding CRM UUID
    
    -- Sync Details
    sync_operation VARCHAR(10) CHECK (sync_operation IN ('CREATE', 'UPDATE', 'DELETE')) NOT NULL,
    sync_status VARCHAR(10) CHECK (sync_status IN ('SUCCESS', 'FAILED', 'PENDING')) NOT NULL,
    sync_direction VARCHAR(15) CHECK (sync_direction IN ('ERP_TO_CRM', 'CRM_TO_ERP')) NOT NULL,
    
    -- Error Handling
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    
    -- Timing
    sync_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_timestamp TIMESTAMP
);

-- Mapping table for ERP-CRM entity relationships
CREATE TABLE erp_entity_mapping (
    mapping_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    erp_entity_type VARCHAR(50) NOT NULL,
    erp_entity_id VARCHAR(50) NOT NULL,
    crm_entity_type VARCHAR(50) NOT NULL,
    crm_entity_id UUID NOT NULL,
    
    -- Mapping metadata
    mapping_status VARCHAR(20) CHECK (mapping_status IN ('Active', 'Inactive', 'Deprecated')) DEFAULT 'Active',
    last_validated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(erp_entity_type, erp_entity_id, crm_entity_type)
);

-- =============================================
-- ANALYTICS AND REPORTING VIEWS


-- Customer health score view
CREATE VIEW customer_health_score AS
SELECT 
    c.customer_id,
    c.company_name,
    COUNT(cs.subscription_id) as active_services,
    AVG(cs.renewal_probability) as avg_renewal_probability,
    AVG(cs.churn_risk_score) as avg_churn_risk,
    COUNT(st.ticket_id) as open_tickets,
    CASE 
        WHEN MAX(i.interaction_date) IS NULL THEN 9999
        ELSE EXTRACT(DAY FROM (CURRENT_DATE - DATE(MAX(i.interaction_date))))
    END as days_since_last_interaction,
    CASE 
        WHEN AVG(cs.churn_risk_score) > 0.7 THEN 'At Risk'
        WHEN AVG(cs.churn_risk_score) > 0.4 THEN 'Medium Risk'
        ELSE 'Healthy'
    END as health_status
FROM customers c
LEFT JOIN customer_services cs ON c.customer_id = cs.customer_id AND cs.service_status = 'Active'
LEFT JOIN support_tickets st ON c.customer_id = st.customer_id AND st.status IN ('Open', 'In Progress')
LEFT JOIN interactions i ON c.customer_id = i.customer_id
WHERE c.customer_status = 'Active'
GROUP BY c.customer_id, c.company_name;



-- =============================================
-- ADDITIONAL CONSTRAINTS AND RELATIONSHIPS


-- Add foreign key constraints for user references
ALTER TABLE customers ADD CONSTRAINT fk_customers_sales_rep 
    FOREIGN KEY (assigned_sales_rep) REFERENCES users(user_id);

ALTER TABLE customers ADD CONSTRAINT fk_customers_account_manager 
    FOREIGN KEY (assigned_account_manager) REFERENCES users(user_id);

ALTER TABLE customers ADD CONSTRAINT fk_customers_created_by 
    FOREIGN KEY (created_by) REFERENCES users(user_id);

ALTER TABLE customers ADD CONSTRAINT fk_customers_updated_by 
    FOREIGN KEY (updated_by) REFERENCES users(user_id);

ALTER TABLE opportunities ADD CONSTRAINT fk_opportunities_owner 
    FOREIGN KEY (owner_id) REFERENCES users(user_id);

ALTER TABLE opportunities ADD CONSTRAINT fk_opportunities_created_by 
    FOREIGN KEY (created_by) REFERENCES users(user_id);

ALTER TABLE customer_services ADD CONSTRAINT fk_customer_services_opportunity 
    FOREIGN KEY (sales_opportunity_id) REFERENCES opportunities(opportunity_id);

ALTER TABLE interactions ADD CONSTRAINT fk_interactions_performed_by 
    FOREIGN KEY (performed_by) REFERENCES users(user_id);

ALTER TABLE support_tickets ADD CONSTRAINT fk_support_tickets_assigned_to 
    FOREIGN KEY (assigned_to) REFERENCES users(user_id);

ALTER TABLE support_tickets ADD CONSTRAINT fk_support_tickets_escalated_to 
    FOREIGN KEY (escalated_to) REFERENCES users(user_id);



-- =============================================
-- TRIGGERS FOR AUTOMATIC UPDATES


-- Trigger to update total_price in opportunity_line_items
-- Note: This is PostgreSQL syntax. Adjust for other databases.
CREATE OR REPLACE FUNCTION calculate_line_item_total()
RETURNS TRIGGER AS $
BEGIN
    NEW.total_price = NEW.quantity * NEW.unit_price * (1 - NEW.discount_percent/100);
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_line_item_total
    BEFORE INSERT OR UPDATE ON opportunity_line_items
    FOR EACH ROW
    EXECUTE FUNCTION calculate_line_item_total();

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

-- Apply timestamp trigger to relevant tables
CREATE TRIGGER trigger_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_contacts_updated_at
    BEFORE UPDATE ON contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_services_updated_at
    BEFORE UPDATE ON services
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_customer_services_updated_at
    BEFORE UPDATE ON customer_services
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_opportunities_updated_at
    BEFORE UPDATE ON opportunities
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_interactions_updated_at
    BEFORE UPDATE ON interactions
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- =============================================
-- PROCEDURES FOR COMMON OPERATIONS


-- Procedure to create a new customer with validation
CREATE OR REPLACE FUNCTION create_customer(
    p_erp_customer_id VARCHAR(50),
    p_company_name VARCHAR(255),
    p_customer_type VARCHAR(20),
    p_primary_email VARCHAR(255),
    p_created_by UUID
) RETURNS UUID AS $
DECLARE
    v_customer_id UUID;
BEGIN
    -- Validate input
    IF p_erp_customer_id IS NULL OR p_company_name IS NULL THEN
        RAISE EXCEPTION 'ERP Customer ID and Company Name are required';
    END IF;
    
    -- Insert customer
    INSERT INTO customers (
        erp_customer_id, company_name, customer_type, 
        primary_email, created_by, customer_status
    ) VALUES (
        p_erp_customer_id, p_company_name, p_customer_type,
        p_primary_email, p_created_by, 'Prospect'
    ) RETURNING customer_id INTO v_customer_id;
    
    -- Log sync operation
    INSERT INTO erp_sync_log (
        entity_type, entity_id, crm_entity_id, 
        sync_operation, sync_status, sync_direction
    ) VALUES (
        'Customer', p_erp_customer_id, v_customer_id,
        'CREATE', 'SUCCESS', 'CRM_TO_ERP'
    );
    
    RETURN v_customer_id;
END;
$ LANGUAGE plpgsql;

-- Procedure to update service status from ERP
CREATE OR REPLACE FUNCTION update_service_status_from_erp(
    p_erp_subscription_id VARCHAR(50),
    p_new_status VARCHAR(20),
    p_activation_date DATE DEFAULT NULL,
    p_suspension_date DATE DEFAULT NULL,
    p_termination_date DATE DEFAULT NULL
) RETURNS BOOLEAN AS $
DECLARE
    v_subscription_id UUID;
BEGIN
    -- Update service status
    UPDATE customer_services 
    SET service_status = p_new_status,
        activation_date = COALESCE(p_activation_date, activation_date),
        suspension_date = COALESCE(p_suspension_date, suspension_date),
        termination_date = COALESCE(p_termination_date, termination_date),
        last_erp_sync = CURRENT_TIMESTAMP,
        erp_sync_status = 'Synced'
    WHERE erp_subscription_id = p_erp_subscription_id
    RETURNING subscription_id INTO v_subscription_id;
    
    -- Check if update was successful
    IF v_subscription_id IS NULL THEN
        -- Log failed sync
        INSERT INTO erp_sync_log (
            entity_type, entity_id, sync_operation, 
            sync_status, sync_direction, error_message
        ) VALUES (
            'Subscription', p_erp_subscription_id, 'UPDATE',
            'FAILED', 'ERP_TO_CRM', 'Subscription not found in CRM'
        );
        RETURN FALSE;
    ELSE
        -- Log successful sync
        INSERT INTO erp_sync_log (
            entity_type, entity_id, crm_entity_id,
            sync_operation, sync_status, sync_direction
        ) VALUES (
            'Subscription', p_erp_subscription_id, v_subscription_id,
            'UPDATE', 'SUCCESS', 'ERP_TO_CRM'
        );
        RETURN TRUE;
    END IF;
END;
$ LANGUAGE plpgsql;

-- generate ticket numbers
CREATE OR REPLACE FUNCTION generate_ticket_number()
RETURNS VARCHAR(20) AS $
DECLARE
    v_year VARCHAR(4);
    v_sequence INTEGER;
    v_ticket_number VARCHAR(20);
BEGIN
    v_year := EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR;
    
    -- Get next sequence number for the year
    SELECT COALESCE(MAX(CAST(SUBSTRING(ticket_number FROM 6) AS INTEGER)), 0) + 1
    INTO v_sequence
    FROM support_tickets 
    WHERE ticket_number LIKE v_year || '-%';
    
    v_ticket_number := v_year || '-' || LPAD(v_sequence::VARCHAR, 6, '0');
    
    RETURN v_ticket_number;
END;
$ LANGUAGE plpgsql;



-- Trigger to auto-generate ticket numbers
CREATE OR REPLACE FUNCTION set_ticket_number()
RETURNS TRIGGER AS $
BEGIN
    IF NEW.ticket_number IS NULL THEN
        NEW.ticket_number = generate_ticket_number();
    END IF;
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_ticket_number
    BEFORE INSERT ON support_tickets
    FOR EACH ROW
    EXECUTE FUNCTION set_ticket_number();

-- Sales pipeline view
CREATE VIEW sales_pipeline AS
SELECT 
    o.stage,
    COUNT(*) as opportunity_count,
    SUM(o.estimated_value) as total_pipeline_value,
    AVG(o.probability) as avg_probability,
    SUM(o.estimated_value * o.probability) as weighted_pipeline_value
FROM opportunities o
WHERE o.status = 'Open'
GROUP BY o.stage
ORDER BY 
    CASE o.stage
        WHEN 'Qualification' THEN 1
        WHEN 'Needs Analysis' THEN 2
        WHEN 'Proposal' THEN 3
        WHEN 'Negotiation' THEN 4
        WHEN 'Closed Won' THEN 5
        WHEN 'Closed Lost' THEN 6
    END;

-- ========================
-- PERFORMANCE INDEX


-- Customer indexes
CREATE INDEX idx_customers_erp_id ON customers(erp_customer_id);
CREATE INDEX idx_customers_status ON customers(customer_status);
CREATE INDEX idx_customers_assigned_rep ON customers(assigned_sales_rep);


-- Contact indexes
CREATE INDEX idx_contacts_customer ON contacts(customer_id);
CREATE INDEX idx_contacts_primary ON contacts(customer_id, is_primary_contact);


-- Service indexes
CREATE INDEX idx_services_erp_id ON services(erp_service_id);
CREATE INDEX idx_services_active ON services(is_active);


-- Customer service indexes
CREATE INDEX idx_customer_services_customer ON customer_services(customer_id);
CREATE INDEX idx_customer_services_status ON customer_services(service_status);
CREATE INDEX idx_customer_services_erp_id ON customer_services(erp_subscription_id);


-- Opportunity indexes
CREATE INDEX idx_opportunities_customer ON opportunities(customer_id);
CREATE INDEX idx_opportunities_stage ON opportunities(stage);
CREATE INDEX idx_opportunities_owner ON opportunities(owner_id);
CREATE INDEX idx_opportunities_close_date ON opportunities(expected_close_date);


-- Interaction indexes
CREATE INDEX idx_interactions_customer ON interactions(customer_id);
CREATE INDEX idx_interactions_date ON interactions(interaction_date);
CREATE INDEX idx_interactions_type ON interactions(interaction_type);


-- Support ticket indexes
CREATE INDEX idx_tickets_customer ON support_tickets(customer_id);
CREATE INDEX idx_tickets_status ON support_tickets(status);
CREATE INDEX idx_tickets_assigned ON support_tickets(assigned_to);


-- ERP sync indexes
CREATE INDEX idx_erp_sync_entity ON erp_sync_log(entity_type, entity_id);
CREATE INDEX idx_erp_sync_status ON erp_sync_log(sync_status);
CREATE INDEX idx_erp_mapping_erp ON erp_entity_mapping(erp_entity_type, erp_entity_id);
