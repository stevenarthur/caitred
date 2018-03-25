class CreateCustomerOrderCountByDateFunction < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP FUNCTION IF EXISTS customer_order_count_by_date(start_date timestamp without time zone, end_date timestamp without time zone);

      CREATE OR REPLACE FUNCTION customer_order_count_by_date(start_date timestamp without time zone, end_date timestamp without time zone)
      RETURNS TABLE(customer_id uuid, order_count bigint) AS $$
      BEGIN
        return query
        select c.id as customer_id, COUNT(e.*) AS order_count
        from Customers c inner join Enquiries e
        on e.customer_id = c.id
        where e.status in ('#{EnquiryStatus::CONFIRMED}', '#{EnquiryStatus::DELIVERED}', '#{EnquiryStatus::COMPLETED}')
        and e.created_at >= start_date
        and e.created_at <= end_date
        group by c.id;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS customer_order_count_by_date(start_date timestamp without time zone, end_date timestamp without time zone);
    SQL
  end
end
