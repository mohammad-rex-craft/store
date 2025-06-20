CREATE OR REPLACE FUNCTION delete_order(
  p_id bigint,
  p_warehouse_id uuid
) RETURNS jsonb AS $$
DECLARE
  current_order orders%ROWTYPE;
  item record;
  store_item store%ROWTYPE;
BEGIN
  -- 1. الحصول على سجل الطلب الحالي
  SELECT * INTO current_order FROM orders WHERE id = p_id AND warehouse_id = p_warehouse_id;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('error', 'Order record not found');
  END IF;

  -- 2. إرجاع الكميات إلى المخزون (زيادة)
  FOR item IN SELECT * FROM jsonb_to_recordset(current_order.items) AS x(id bigint, qtn integer)
  LOOP
    -- التحقق من وجود العنصر في المخزون
    SELECT * INTO store_item FROM store WHERE id = item.id AND warehouse_id = p_warehouse_id;
    
    IF FOUND THEN
      -- زيادة الكمية في المخزون
      UPDATE store 
      SET qtn = qtn + item.qtn
      WHERE id = item.id AND warehouse_id = p_warehouse_id;
    ELSE
      -- يمكنك إضافة رسالة تحذير إذا لزم الأمر
      RAISE NOTICE 'Store item not found: %', item.id;
    END IF;
  END LOOP;

  -- 3. حذف سجل الطلب
  DELETE FROM orders WHERE id = p_id AND warehouse_id = p_warehouse_id;

  RETURN jsonb_build_object('success', true, 'message', 'Order deleted and inventory updated successfully');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;