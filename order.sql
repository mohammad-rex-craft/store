DROP FUNCTION IF EXISTS public.update_order(bigint, text, text, jsonb);
DROP FUNCTION IF EXISTS public.update_order(bigint, text, text, text);

CREATE OR REPLACE FUNCTION update_order_v1(
  p_id bigint,
  p_warehouse_id uuid,
  p_new_date text DEFAULT NULL,
  p_new_noa text DEFAULT NULL,
  p_new_client text DEFAULT NULL,
  p_new_sender text DEFAULT NULL,
  p_new_items text DEFAULT NULL
) RETURNS jsonb AS $$
DECLARE
  current_order orders%ROWTYPE;
  old_item record;
  new_item jsonb;
  new_items_ids jsonb := '[]'::jsonb;
  item_exists boolean;
  new_items_json jsonb;
BEGIN
  -- 1. تحويل النص إلى jsonb والتحقق من الصحة
  BEGIN
    new_items_json := p_new_items::jsonb;
  EXCEPTION WHEN others THEN
    RETURN jsonb_build_object('error', 'Invalid JSON format for items');
  END;

  IF jsonb_typeof(new_items_json) != 'array' THEN
    RETURN jsonb_build_object('error', 'Items must be a JSON array');
  END IF;

  -- 2. الحصول على سجل الطلب الحالي
  SELECT * INTO current_order FROM orders WHERE id = p_id AND warehouse_id = p_warehouse_id;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('error', 'Order record not found');
  END IF;

  -- 3. إرجاع الكميات القديمة إلى المخزون (زيادة)
  FOR old_item IN SELECT * FROM jsonb_to_recordset(current_order.items) AS x(id bigint, qtn integer)
  LOOP
    -- التحقق من وجود العنصر في المخزون
    SELECT EXISTS(SELECT 1 FROM store WHERE id = old_item.id AND warehouse_id = p_warehouse_id) INTO item_exists;
    IF NOT item_exists THEN
      RETURN jsonb_build_object('error', 'Old store item not found: ' || old_item.id);
    END IF;

    -- زيادة الكمية في المخزون
    UPDATE store 
    SET qtn = qtn + old_item.qtn
    WHERE id = old_item.id AND warehouse_id = p_warehouse_id;
  END LOOP;

  -- 4. خصم الكميات الجديدة من المخزون
  FOR new_item IN SELECT * FROM jsonb_array_elements(new_items_json)
  LOOP
    -- التحقق من أن العنصر يحتوي على الحقول المطلوبة
    IF (new_item->>'id') IS NULL OR (new_item->>'qtn') IS NULL THEN
      RETURN jsonb_build_object('error', 'Each item must have id and qtn fields');
    END IF;

    -- التحقق من وجود العنصر الجديد في المخزون
    SELECT EXISTS(SELECT 1 FROM store WHERE id = (new_item->>'id')::bigint AND warehouse_id = p_warehouse_id) INTO item_exists;
    IF NOT item_exists THEN
      RETURN jsonb_build_object('error', 'New store item not found: ' || (new_item->>'id'));
    END IF;

    -- خصم الكمية من المخزون
    UPDATE store
    SET qtn = qtn - (new_item->>'qtn')::integer
    WHERE id = (new_item->>'id')::bigint AND warehouse_id = p_warehouse_id;
    
    -- تجميع IDs العناصر الجديدة
    new_items_ids := new_items_ids || jsonb_build_array((new_item->>'id')::bigint);
  END LOOP;

  -- 5. تحديث سجل الطلب
  UPDATE orders
  SET 
    date = COALESCE(p_new_date, date),
    noa = COALESCE(p_new_noa, noa),
    client = COALESCE(p_new_client, client),
    sender = COALESCE(p_new_sender, sender),
    items_ids = new_items_ids,
    items = new_items_json
  WHERE id = p_id;

  RETURN jsonb_build_object('success', true, 'message', 'Order and inventory updated successfully');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;