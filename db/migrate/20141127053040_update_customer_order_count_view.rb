class UpdateCustomerOrderCountView < ActiveRecord::Migration
   def up
    execute 'drop view customer_order_count'
    sql = <<-SQL
      create view customer_order_count as
        select c.id, c.first_name, c.last_name, c.email, c.created_at, count(e.*)
        from customers c
        inner join enquiries e on e.customer_id = c.id
        where e.status in ('#{EnquiryStatus::CONFIRMED}', '#{EnquiryStatus::DELIVERED}', '#{EnquiryStatus::COMPLETED}')
        and e.created_at > now() - interval '1 year'
        group by c.id, c.first_name, c.last_name, c.email, c.created_at
    SQL
    execute sql
  end

  def down
    execute 'drop view customer_order_count'
    sql = <<-SQL
      create view customer_order_count as
        select c.id, c.first_name, c.last_name, c.email, c.created_at, count(e.*)
        from customers c
        inner join enquiries e on e.customer_id = c.id
        where c.created_at > '1 nov 2014'
        group by c.id, c.first_name, c.last_name, c.email, c.created_at
    SQL
    execute sql
  end
end
