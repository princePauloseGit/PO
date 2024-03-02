query 50127 GetAllSalesLineItems
{
    Caption = 'Get All SalesLine Items';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            column(ATOWhseOutstandingQty; "ATO Whse. Outstanding Qty.")
            {
            }
            column(ATOWhseOutstdQtyBase; "ATO Whse. Outstd. Qty. (Base)")
            {
            }
            column(AllowInvoiceDisc; "Allow Invoice Disc.")
            {
            }
            column(AllowItemChargeAssignment; "Allow Item Charge Assignment")
            {
            }
            column(AllowLineDisc; "Allow Line Disc.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Description2; "Description 2")
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup; "Gen. Prod. Posting Group")
            {
            }
            column(GrossWeight; "Gross Weight")
            {
            }
            column(ItemCategoryCode; "Item Category Code")
            {
            }
            column(ItemReferenceNo; "Item Reference No.")
            {
            }
            column(ItemReferenceType; "Item Reference Type")
            {
            }
            column(ItemReferenceTypeNo; "Item Reference Type No.")
            {
            }
            column(ItemReferenceUnitofMeasure; "Item Reference Unit of Measure")
            {
            }
            column(LineAmount; "Line Amount")
            {
            }
            column(LineDiscount; "Line Discount %")
            {
            }
            column(LineDiscountAmount; "Line Discount Amount")
            {
            }
            column(LineDiscountCalculation; "Line Discount Calculation")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(NetWeight; "Net Weight")
            {
            }
            column(No; "No.")
            {
            }
            column(Nonstock; Nonstock)
            {
            }
            column(OutstandingAmount; "Outstanding Amount")
            {
            }
            column(OutstandingAmountLCY; "Outstanding Amount (LCY)")
            {
            }
            column(OutstandingQtyBase; "Outstanding Qty. (Base)")
            {
            }
            column(OutstandingQuantity; "Outstanding Quantity")
            {
            }
            column(PickCreated; "Pick Created")
            {
            }
            column(Planned; Planned)
            {
            }
            column(PlannedDeliveryDate; "Planned Delivery Date")
            {
            }
            column(PlannedShipmentDate; "Planned Shipment Date")
            {
            }
            column(PmtDiscountAmount; "Pmt. Discount Amount")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingGroup; "Posting Group")
            {
            }
            column(PriceCalculationMethod; "Price Calculation Method")
            {
            }
            column(Pricedescription; "Price description")
            {
            }
            column(Profit; "Profit %")
            {
            }
            column(PromisedDeliveryDate; "Promised Delivery Date")
            {
            }
            column(PurchOrderLineNo; "Purch. Order Line No.")
            {
            }
            column(PurchaseOrderNo; "Purchase Order No.")
            {
            }
            column(PurchasingCode; "Purchasing Code")
            {
            }
            column(QtyAssigned; "Qty. Assigned")
            {
            }
            column(QtyInvoicedBase; "Qty. Invoiced (Base)")
            {
            }
            column(QtyRoundingPrecision; "Qty. Rounding Precision")
            {
            }
            column(QtyRoundingPrecisionBase; "Qty. Rounding Precision (Base)")
            {
            }
            column(QtyShippedBase; "Qty. Shipped (Base)")
            {
            }
            column(QtyShippedNotInvdBase; "Qty. Shipped Not Invd. (Base)")
            {
            }
            column(QtyShippedNotInvoiced; "Qty. Shipped Not Invoiced")
            {
            }
            column(QtyperUnitofMeasure; "Qty. per Unit of Measure")
            {
            }
            column(QtytoAsmtoOrderBase; "Qty. to Asm. to Order (Base)")
            {
            }
            column(QtytoAssembletoOrder; "Qty. to Assemble to Order")
            {
            }
            column(QtytoAssign; "Qty. to Assign")
            {
            }
            column(QtytoInvoice; "Qty. to Invoice")
            {
            }
            column(QtytoInvoiceBase; "Qty. to Invoice (Base)")
            {
            }
            column(QtytoShip; "Qty. to Ship")
            {
            }
            column(QtytoShipBase; "Qty. to Ship (Base)")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(QuantityBase; "Quantity (Base)")
            {
            }
            column(QuantityInvoiced; "Quantity Invoiced")
            {
            }
            column(QuantityShipped; "Quantity Shipped")
            {
            }
            column(Reserve; Reserve)
            {
            }
            column(ReservedQtyBase; "Reserved Qty. (Base)")
            {
            }
            column(ReservedQuantity; "Reserved Quantity")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(RetQtyRcdNotInvdBase; "Ret. Qty. Rcd. Not Invd.(Base)")
            {
            }
            column(ReturnQtyRcdNotInvd; "Return Qty. Rcd. Not Invd.")
            {
            }
            column(ReturnQtyReceived; "Return Qty. Received")
            {
            }
            column(ReturnQtyReceivedBase; "Return Qty. Received (Base)")
            {
            }
            column(ReturnQtytoReceive; "Return Qty. to Receive")
            {
            }
            column(ReturnQtytoReceiveBase; "Return Qty. to Receive (Base)")
            {
            }
            column(ReturnRcdNotInvd; "Return Rcd. Not Invd.")
            {
            }
            column(ReturnRcdNotInvdLCY; "Return Rcd. Not Invd. (LCY)")
            {
            }
            column(ReturnReasonCode; "Return Reason Code")
            {
            }
            column(ReturnReceiptLineNo; "Return Receipt Line No.")
            {
            }
            column(ReturnReceiptNo; "Return Receipt No.")
            {
            }
            column(ReturnsDeferralStartDate; "Returns Deferral Start Date")
            {
            }
            column(ReverseCharge; "Reverse Charge")
            {
            }
            column(ReverseChargeItem; "Reverse Charge Item")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }

            column(ShipmentDate; "Shipment Date")
            {
            }
            column(ShipmentLineNo; "Shipment Line No.")
            {
            }
            column(ShipmentNo; "Shipment No.")
            {
            }
            column(ShippedNotInvLCYNoVAT; "Shipped Not Inv. (LCY) No VAT")
            {
            }
            column(ShippedNotInvoiced; "Shipped Not Invoiced")
            {
            }
            column(ShippedNotInvoicedLCY; "Shipped Not Invoiced (LCY)")
            {
            }
            column(ShippingAgentCode; "Shipping Agent Code")
            {
            }
            column(ShippingAgentServiceCode; "Shipping Agent Service Code")
            {
            }
            column(ShippingTime; "Shipping Time")
            {
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(SpecialOrder; "Special Order")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column("Type"; "Type")
            {
            }
            column(UnitCost; "Unit Cost")
            {
            }
            column(UnitCostLCY; "Unit Cost (LCY)")
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(UnitVolume; "Unit Volume")
            {
            }
            column(UnitofMeasure; "Unit of Measure")
            {
            }

            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(UnitsperParcel; "Units per Parcel")
            {
            }
            column(UseDuplicationList; "Use Duplication List")
            {
            }
            column(VAT; "VAT %")
            {
            }
            column(VATBaseAmount; "VAT Base Amount")
            {
            }
            column(VATBusPostingGroup; "VAT Bus. Posting Group")
            {
            }
            column(VATCalculationType; "VAT Calculation Type")
            {
            }
            column(VATClauseCode; "VAT Clause Code")
            {
            }
            column(VATDifference; "VAT Difference")
            {
            }
            column(VATIdentifier; "VAT Identifier")
            {
            }
            column(VATProdPostingGroup; "VAT Prod. Posting Group")
            {
            }
            column(VariantCode; "Variant Code")
            {
            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "No." = SalesLine."Document No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                ExcludeSOOrder = const(false);
                column(Order_Date; "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
