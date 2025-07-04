DROP FUNCTION IF EXISTS public.update_input(bigint, text, text, jsonb);
DROP FUNCTION IF EXISTS public.update_input(bigint, text, text, text);


CREATE OR REPLACE FUNCTION public.update_input_v1(
  p_id bigint,
  p_warehouse_id uuid,
  p_new_noa text DEFAULT NULL,
  p_new_type text DEFAULT NULL,
  p_new_items text DEFAULT NULL
) RETURNS jsonb AS $$
DECLARE
  current_input inputs%ROWTYPE;
  old_item record;
  new_item jsonb;
  new_items_ids jsonb := '[]'::jsonb;
  item_exists boolean;
  new_items_json jsonb;
BEGIN
  -- 1. تحويل النص إلى jsonb
  BEGIN
    new_items_json := p_new_items::jsonb;
  EXCEPTION WHEN others THEN
    RETURN jsonb_build_object('error', 'Invalid JSON format for items');
  END;

  -- 2. التحقق من أن البيانات هي مصفوفة
  IF jsonb_typeof(new_items_json) != 'array' THEN
    RETURN jsonb_build_object('error', 'Items must be a JSON array');
  END IF;

  -- 3. الحصول على سجل الإدخال الحالي مع التحقق من المستودع
  SELECT * INTO current_input FROM inputs WHERE id = p_id AND warehouse_id = p_warehouse_id;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('error', 'Input record not found for the specified warehouse');
  END IF;

  -- 4. الخصم من المخزون للعناصر القديمة في نفس المستودع
  FOR old_item IN SELECT * FROM jsonb_to_recordset(current_input.items) AS x(id bigint, qtn integer)
  LOOP
    -- التحقق من وجود العنصر في المخزون لنفس المستودع
    SELECT EXISTS(SELECT 1 FROM store WHERE id = old_item.id AND warehouse_id = p_warehouse_id) INTO item_exists;
    IF NOT item_exists THEN
      RETURN jsonb_build_object('error', 'Old store item not found in the specified warehouse: ' || old_item.id);
    END IF;

    -- خصم الكمية من المخزون
    UPDATE store 
    SET qtn = qtn - old_item.qtn
    WHERE id = old_item.id AND warehouse_id = p_warehouse_id;
  END LOOP;

  -- 5. الإضافة إلى المخزون للعناصر الجديدة في نفس المستودع
  FOR new_item IN SELECT * FROM jsonb_array_elements(new_items_json)
  LOOP
    -- التحقق من أن العنصر يحتوي على الحقول المطلوبة
    IF (new_item->>'id') IS NULL OR (new_item->>'qtn') IS NULL THEN
      RETURN jsonb_build_object('error', 'Each item must have id and qtn fields');
    END IF;

    -- التحقق من وجود العنصر الجديد في المخزون لنفس المستودع
    SELECT EXISTS(SELECT 1 FROM store WHERE id = (new_item->>'id')::bigint AND warehouse_id = p_warehouse_id) INTO item_exists;
    IF NOT item_exists THEN
      RETURN jsonb_build_object('error', 'New store item not found in the specified warehouse: ' || (new_item->>'id'));
    END IF;

    -- إضافة الكمية إلى المخزون
    UPDATE store
    SET qtn = qtn + (new_item->>'qtn')::integer
    WHERE id = (new_item->>'id')::bigint AND warehouse_id = p_warehouse_id;
    
    -- تجميع IDs العناصر الجديدة كـ JSONB
    new_items_ids := new_items_ids || jsonb_build_array((new_item->>'id')::bigint);
  END LOOP;

  -- 6. تحديث سجل الإدخال
  UPDATE inputs
  SET 
    noa = COALESCE(p_new_noa, noa),
    type = COALESCE(p_new_type, type),
    items_ids = new_items_ids,
    items = new_items_json
  WHERE id = p_id AND warehouse_id = p_warehouse_id;

  RETURN jsonb_build_object('success', true, 'message', 'Input and inventory updated successfully');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;