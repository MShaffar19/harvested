module Harvest
  class Base
    attr_reader :request, :credentials

    # @see Harvest.client
    # @see Harvest.hardy_client
    def initialize(
      subdomain: nil,
      username: nil,
      password: nil,
      access_token: nil
    )
      @credentials = if subdomain && username && password
        BasicAuthCredentials.new(
          subdomain: subdomain,
          username: username,
          password: password
        )
      elsif access_token
        OAuthCredentials.new(access_token)
      else
        fail 'You must provide either :subdomain, :username, and :password ' \
          'or an oauth :access_token'
      end
    end

    # All API actions surrounding accounts
    #
    # == Examples
    #  harvest.account.rate_limit_status # Returns a Harvest::RateLimitStatus
    #
    # @return [Harvest::API::Account]
    def account
      @account ||= Harvest::API::Account.new(credentials)
    end

    # All API Actions surrounding Clients
    #
    # == Examples
    #  harvest.clients.all() # Returns all clients in the system
    #
    #  harvest.clients.find(100) # Returns the client with id = 100
    #
    #  client = Harvest::Client.new(:name => 'SuprCorp')
    #  # returns a saved version of Harvest::Client
    #  saved_client = harvest.clients.create(client)
    #
    #  client = harvest.clients.find(205)
    #  client.name = 'SuprCorp LTD.'
    #  # returns an updated version of Harvest::Client
    #  updated_client = harvest.clients.update(client)
    #
    #  client = harvest.clients.find(205)
    #  harvest.clients.delete(client) # returns 205
    #
    #  client = harvest.clients.find(301)
    #  # returns an updated deactivated client
    #  deactivated_client = harvest.clients.deactivate(client)
    #  # returns an updated activated client
    #  activated_client = harvest.clients.activate(client)
    #
    # @see Harvest::Behavior::Crud
    # @see Harvest::Behavior::Activatable
    # @return [Harvest::API::Clients]
    def clients
      @clients ||= Harvest::API::Clients.new(credentials)
    end

    # All API Actions surrounding Client Contacts
    #
    # == Examples
    #  harvest.contacts.all() # Returns all contacts in the system
    #  harvest.contacts.all(10) # Returns all contacts for the client id=10
    #  in the system
    #
    #  harvest.contacts.find(100) # Returns the contact with id = 100
    #
    #  contact = Harvest::Contact.new(
    #    :first_name => 'Jane',
    #    :last_name => 'Doe',
    #    :client_id => 10
    #  )
    #  # returns a saved version of Harvest::Contact
    #  saved_contact = harvest.contacts.create(contact)
    #
    #  contact = harvest.contacts.find(205)
    #  contact.first_name = 'Jilly'
    #  # returns an updated version of Harvest::Contact
    #  updated_contact = harvest.contacts.update(contact)
    #
    #  contact = harvest.contacts.find(205)
    #  harvest.contacts.delete(contact) # returns 205
    #
    # @see Harvest::Behavior::Crud
    # @return [Harvest::API::Contacts]
    def contacts
      @contacts ||= Harvest::API::Contacts.new(credentials)
    end

    # All API Actions surrounding Projects
    #
    # == Examples
    #  harvest.projects.all() # Returns all projects in the system
    #
    #  harvest.projects.find(100) # Returns the project with id = 100
    #
    #  project = Harvest::Project.new(:name => 'SuprGlu' :client_id => 10)
    #  # returns a saved version of Harvest::Project
    #  saved_project = harvest.projects.create(project)
    #
    #  project = harvest.projects.find(205)
    #  project.name = 'SuprSticky'
    #  # returns an updated version of Harvest::Project
    #  updated_project = harvest.projects.update(project)
    #
    #  project = harvest.project.find(205)
    #  harvest.projects.delete(project) # returns 205
    #
    #  project = harvest.projects.find(301)
    #  # returns an updated deactivated project
    #  deactivated_project = harvest.projects.deactivate(project)
    #  # returns an updated activated project
    #  activated_project = harvest.projects.activate(project)
    #
    #  project = harvest.projects.find(401)
    #  # creates and assigns a task to the project
    #  harvest.projects.create_task(project, 'Bottling Glue')
    #
    # @see Harvest::Behavior::Crud
    # @see Harvest::Behavior::Activatable
    # @return [Harvest::API::Projects]
    def projects
      @projects ||= Harvest::API::Projects.new(credentials)
    end

    # All API Actions surrounding Tasks
    #
    # == Examples
    #  harvest.tasks.all() # Returns all tasks in the system
    #
    #  harvest.tasks.find(100) # Returns the task with id = 100
    #
    #  task = Harvest::Task.new(
    #    :name => 'Server Administration',
    #    :default => true
    #  )
    #  # returns a saved version of Harvest::Task
    #  saved_task = harvest.tasks.create(task)
    #
    #  task = harvest.tasks.find(205)
    #  task.name = 'Server Administration'
    #  # returns an updated version of Harvest::Task
    #  updated_task = harvest.tasks.update(task)
    #
    #  task = harvest.task.find(205)
    #  harvest.tasks.delete(task) # returns 205
    #
    # @see Harvest::Behavior::Crud
    # @return [Harvest::API::Tasks]
    def tasks
      @tasks ||= Harvest::API::Tasks.new(credentials)
    end

    # All API Actions surrounding Users
    #
    # == Examples
    #  harvest.users.all() # Returns all users in the system
    #
    #  harvest.users.find(100) # Returns the user with id = 100
    #
    #  user = Harvest::User.new(
    #    :first_name => 'Edgar',
    #    :last_name => 'Ruth',
    #    :email => 'edgar@ruth.com',
    #    :password => 'mypassword',
    #    :timezone => :cst,
    #    :admin => false,
    #    :telephone => '444-4444'
    #  )
    #  # returns a saved version of Harvest::User
    #  saved_user = harvest.users.create(user)
    #
    #  user = harvest.users.find(205)
    #  user.email = 'edgar@ruth.com'
    #  # returns an updated version of Harvest::User
    #  updated_user = harvest.users.update(user)
    #
    #  user = harvest.users.find(205)
    #  harvest.users.delete(user) # returns 205
    #
    #  user = harvest.users.find(301)
    #  # returns an updated deactivated user
    #  deactivated_user = harvest.users.deactivate(user)
    #  # returns an updated activated user
    #  activated_user = harvest.users.activate(user)
    #
    #  user = harvest.users.find(401)
    #  # will trigger the reset password feature of harvest and shoot the
    #  # user an email
    #  harvest.users.reset_password(user)
    #
    # @see Harvest::Behavior::Crud
    # @see Harvest::Behavior::Activatable
    # @return [Harvest::API::Users]
    def users
      @users ||= Harvest::API::Users.new(credentials)
    end

    # All API Actions surrounding assigning tasks to projects
    #
    # == Examples
    #  project = harvest.projects.find(101)
    #  # returns all tasks assigned to the project (as Harvest::TaskAssignment)
    #  harvest.task_assignments.all(project)
    #
    #  project = harvest.projects.find(201)
    #  # returns the task assignment with ID 5 that is assigned to the project
    #  harvest.task_assignments.find(project, 5)
    #
    #  project = harvest.projects.find(301)
    #  task = harvest.tasks.find(100)
    #  assignment = Harvest::TaskAssignment.new(
    #    :task_id => task.id,
    #    :project_id => project.id
    #  )
    #  # returns a saved version of the task assignment
    #  saved_assignment = harvest.task_assignments.create(assignment)
    #
    #  project = harvest.projects.find(401)
    #  assignment = harvest.task_assignments.find(project, 15)
    #  assignment.hourly_rate = 150
    #  # returns an updated assignment
    #  updated_assignment = harvest.task_assignments.update(assignment)
    #
    #  project = harvest.projects.find(501)
    #  assignment = harvest.task_assignments.find(project, 25)
    #  harvest.task_assignments.delete(assignment) # returns 25
    #
    # @return [Harvest::API::TaskAssignments]
    def task_assignments
      @task_assignments ||= Harvest::API::TaskAssignments.new(credentials)
    end

    # All API Actions surrounding assigning users to projects
    #
    # == Examples
    #  project = harvest.projects.find(101)
    #  # returns all users assigned to the project (as Harvest::UserAssignment)
    #  harvest.user_assignments.all(project)
    #
    #  project = harvest.projects.find(201)
    #  # returns the user assignment with ID 5 that is assigned to the project
    #  harvest.user_assignments.find(project, 5)
    #
    #  project = harvest.projects.find(301)
    #  user = harvest.users.find(100)
    #  assignment = Harvest::UserAssignment.new(
    #    :user_id => user.id,
    #    :project_id => project.id
    #  )
    #  # returns a saved version of the user assignment
    #  saved_assignment = harvest.user_assignments.create(assignment)
    #
    #  project = harvest.projects.find(401)
    #  assignment = harvest.user_assignments.find(project, 15)
    #  assignment.project_manager = true
    #  # returns an updated assignment
    #  updated_assignment = harvest.user_assignments.update(assignment)
    #
    #  project = harvest.projects.find(501)
    #  assignment = harvest.user_assignments.find(project, 25)
    #  harvest.user_assignments.delete(assignment) # returns 25
    #
    # @return [Harvest::API::UserAssignments]
    def user_assignments
      @user_assignments ||= Harvest::API::UserAssignments.new(credentials)
    end

    # All API Actions surrounding managing expense categories
    #
    # == Examples
    #  # Returns all expense categories in the system
    #  harvest.expense_categories.all()
    #
    #  # Returns the expense category with id = 100
    #  harvest.expense_categories.find(100)
    #
    #  category = Harvest::ExpenseCategory.new(
    #    :name => 'Mileage',
    #    :unit_price => 0.485
    #  )
    #  # returns a saved version of Harvest::ExpenseCategory
    #  saved_category = harvest.expense_categories.create(category)
    #
    #  category = harvest.clients.find(205)
    #  category.name = 'Travel'
    #  # returns an updated version of Harvest::ExpenseCategory
    #  updated_category = harvest.expense_categories.update(category)
    #
    #  category = harvest.expense_categories.find(205)
    #  harvest.expense_categories.delete(category) # returns 205
    #
    # @see Harvest::Behavior::Crud
    # @return [Harvest::API::ExpenseCategories]
    def expense_categories
      @expense_categories ||= Harvest::API::ExpenseCategories.new(credentials)
    end

    # All API Actions surrounding expenses
    #
    # == Examples
    #  harvest.expenses.all() # Returns all expenses for the current week
    #  # returns all expenses for the week of 11/12/2009
    #  harvest.expenses.all(Time.parse('11/12/2009'))
    #
    #  harvest.expenses.find(100) # Returns the expense with id = 100
    def expenses
      @expenses ||= Harvest::API::Expenses.new(credentials)
    end

    def time
      @time ||= Harvest::API::Time.new(credentials)
    end

    def reports
      @reports ||= Harvest::API::Reports.new(credentials)
    end

    def invoice_categories
      @invoice_categories ||= Harvest::API::InvoiceCategories.new(credentials)
    end

    def invoices
      @invoices ||= Harvest::API::Invoices.new(credentials)
    end

    # All API Actions surrounding invoice payments
    #
    # == Examples
    #  invoice = harvest.invoices.find(100)
    #  # returns all payments for the invoice  (as Harvest::InvoicePayment)
    #  harvest.invoice_payments.all(invoice)
    #
    #  invoice = harvest.invoices.find(100)
    #  # returns the payment with ID 5 that is assigned to the invoice
    #  harvest.invoice_payments.find(invoice, 5)
    #
    #  invoice = harvest.invoices.find(100)
    #  payment = Harvest::InvoicePayment.new(:invoice_id => invoice.id)
    #  # returns a saved version of the payment
    #  saved_payment = harvest.invoice_payments.create(payment)
    #
    #  invoice = harvest.invoices.find(100)
    #  payment = harvest.invoice_payments.find(invoice, 5)
    #  harvest.invoice_payments.delete(payment) # returns 5
    #
    # @return [Harvest::API::InvoicePayments]
    def invoice_payments
      @invoice_payments ||= Harvest::API::InvoicePayments.new(credentials)
    end

    # All API Actions surrounding invoice messages
    #
    # == Examples
    #
    #  invoice = harvest.invoices.find(100)
    #  # returns all messages for the invoice (as Harvest::InvoicePayment)
    #  harvest.invoice_messages.all(invoice)
    #
    #  invoice = harvest.invoices.find(100)
    #  # returns the message with ID 5, assigned to the invoice
    #  harvest.invoice_messages.find(invoice, 5)
    #
    #  invoice = harvest.invoices.find(100)
    #  message = Harvest::InvoiceMessage.new(:invoice_id => invoice.id)
    #  # returns a saved version of the message
    #  saved_message = harvest.invoice_messages.create(message)
    #
    #  invoice = harvest.invoices.find(100)
    #  message = harvest.invoice_messages.find(invoice, 5)
    #  harvest.invoice_messages.delete(message) # returns 5
    #
    #  invoice = harvest.invoices.find(100)
    #  message = Harvest::InvoiceMessage.new(:invoice_id => invoice.id)
    #  harvest.invoice_messages.mark_as_sent(message)
    #
    #  invoice = harvest.invoices.find(100)
    #  message = Harvest::InvoiceMessage.new(:invoice_id => invoice.id)
    #  harvest.invoice_messages.mark_as_closed(message)
    #
    #  invoice = harvest.invoices.find(100)
    #  message = Harvest::InvoiceMessage.new(:invoice_id => invoice.id)
    #  harvest.invoice_messages.re_open(message)
    #
    # @return [Harvest::API::InvoiceMessages]
    def invoice_messages
      @invoice_messages ||= Harvest::API::InvoiceMessages.new(credentials)
    end
  end
end
