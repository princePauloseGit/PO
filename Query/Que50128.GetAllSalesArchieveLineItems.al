query 50128 GetAllSalesArchiveLineItems
{
    Caption = 'Get All Sales Archive Line Items';
    QueryType = Normal;

    elements
    {
        dataitem(SalesLineArchive; "Sales Line Archive")
        {
            column(AllowInvoiceDisc; "Allow Invoice Disc.")
            {
            }
            column(AllowItemChargeAssignment; "Allow Item Charge Assignment")
            {
            }
            column(AllowLineDisc; "Allow Line Disc.")
            {
            }
            column(AllowQuantityDisc; "Allow Quantity Disc.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }

            column("Area"; "Area")
            {
            }

            column(BOMItemNo; "BOM Item No.")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(BinCode; "Bin Code")
            {
            }
            column(BlanketOrderLineNo; "Blanket Order Line No.")
            {
            }
            column(BlanketOrderNo; "Blanket Order No.")
            {
            }
            column(CompletelyShipped; "Completely Shipped")
            {
            }
            column(ContainsKitBOMAssembly; "Contains Kit/BOM/Assembly")
            {
            }
            column(CurrencyCode; "Currency Code")
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
            column(DocNoOccurrence; "Doc. No. Occurrence")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DropShipment; "Drop Shipment")
            {
            }

            column(FAPostingDate; "FA Posting Date")
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

            column(InvDiscAmounttoInvoice; "Inv. Disc. Amount to Invoice")
            {
            }
            column(InvDiscountAmount; "Inv. Discount Amount")
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(InvtPickNo; "Invt. Pick No.")
            {
            }
            column(IsNonStockItem; "Is NonStock Item")
            {
            }
            column(IsaMachine; "Is a Machine")
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
            column(JobContractEntryNo; "Job Contract Entry No.")
            {
            }
            column(JobNo; "Job No.")
            {
            }
            column(JobTaskNo; "Job Task No.")
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
            column(OrderDespatchProcessed; "Order Despatch Processed")
            {
            }
            column(OriginallyOrderedNo; "Originally Ordered No.")
            {
            }
            column(OriginallyOrderedVarCode; "Originally Ordered Var. Code")
            {
            }
            column(OutofStockSubstitution; "Out-of-Stock Substitution")
            {
            }
            column(OutboundWhseHandlingTime; "Outbound Whse. Handling Time")
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
            column(PostingGroup; "Posting Group")
            {
            }
            column(Prepayment; "Prepayment %")
            {
            }
            column(PrepaymentAmount; "Prepayment Amount")
            {
            }
            column(PrepaymentLine; "Prepayment Line")
            {
            }
            column(PrepaymentTaxAreaCode; "Prepayment Tax Area Code")
            {
            }
            column(PrepaymentTaxGroupCode; "Prepayment Tax Group Code")
            {
            }
            column(PrepaymentTaxLiable; "Prepayment Tax Liable")
            {
            }
            column(PrepaymentVAT; "Prepayment VAT %")
            {
            }
            column(PrepaymentVATIdentifier; "Prepayment VAT Identifier")
            {
            }
            column(PrepmtAmtDeducted; "Prepmt Amt Deducted")
            {
            }
            column(PrepmtAmttoDeduct; "Prepmt Amt to Deduct")
            {
            }
            column(PrepmtAmountInvInclVAT; "Prepmt. Amount Inv. Incl. VAT")
            {
            }
            column(PrepmtAmtInclVAT; "Prepmt. Amt. Incl. VAT")
            {
            }
            column(PrepmtAmtInv; "Prepmt. Amt. Inv.")
            {
            }
            column(PrepmtLineAmount; "Prepmt. Line Amount")
            {
            }
            column(PrepmtVATBaseAmt; "Prepmt. VAT Base Amt.")
            {
            }
            column(PrepmtVATCalcType; "Prepmt. VAT Calc. Type")
            {
            }
            column(PriceCalculationMethod; "Price Calculation Method")
            {
            }
            column(PriceGroupCode; "Price Group Code")
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
            column(QtyInvoicedBase; "Qty. Invoiced (Base)")
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
            column(QuantityDisc; "Quantity Disc. %")
            {
            }
            column(QuantityDiscCode; "Quantity Disc. Code")
            {
            }
            column(QuantityInvoiced; "Quantity Invoiced")
            {
            }
            column(QuantityShipped; "Quantity Shipped")
            {
            }
            column(RequestedDeliveryDate; "Requested Delivery Date")
            {
            }
            column(Reserve; Reserve)
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(RetAmtRcdNotInvdLCY; "Ret. Amt. Rcd. Not Invd. (LCY)")
            {
            }
            column(RetQtyRcdNotInvdBase; "Ret. Qty. Rcd. Not Invd.(Base)")
            {
            }
            column(ReturnAmtRcdNotInvd; "Return Amt. Rcd. Not Invd.")
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
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(ServPriceAdjmtGrCode; "Serv. Price Adjmt. Gr. Code")
            {
            }
            column(ServiceContractNo; "Service Contract No.")
            {
            }
            column(ServiceItemLineNo; "Service Item Line No.")
            {
            }
            column(ServiceItemNo; "Service Item No.")
            {
            }
            column(ServiceOrderNo; "Service Order No.")
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
            column(SpecialOrderPurchLineNo; "Special Order Purch. Line No.")
            {
            }
            column(SpecialOrderPurchaseNo; "Special Order Purchase No.")
            {
            }
            column(SubstitutionAvailable; "Substitution Available")
            {
            }
            column(SystemCreatedEntry; "System-Created Entry")
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
            column(TaxAreaCode; "Tax Area Code")
            {
            }
            column(TaxGroupCode; "Tax Group Code")
            {
            }
            column(TaxLiable; "Tax Liable")
            {
            }
            column(TesseractAlertSent; TesseractAlertSent)
            {
            }
            column(TransactionSpecification; "Transaction Specification")
            {
            }
            column("TransactionType"; "Transaction Type")
            {
            }
            column(TransportMethod; "Transport Method")
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
            column(UnreservedQty; "Unreserved Qty.")
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
            column(VersionNo; "Version No.")
            {
            }
            column(WorkTypeCode; "Work Type Code")
            {
            }
            column(enhweblineref; enhweblineref)
            {
            }

            dataitem(Sales_Header_Archive; "Sales Header Archive")
            {
                DataItemLink = "No." = SalesLineArchive."Document No.",
                "Version No." = SalesLineArchive."Version No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                //Invoice = const(true),
                 ExcludeSOOrder = const(false);

                column(No__of_Archived_Versions; "No. of Archived Versions")
                {

                }
                column(Order_Date;
                "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }
                column(SalesHeader_Version_No_; "Version No.")
                {

                }
                column(SalesHeaderArchive_SystemCreatedAt; SystemCreatedAt)
                {

                }
                column(Source_Doc__Exists; "Source Doc. Exists")
                {
                    ColumnFilter = Source_Doc__Exists = const(false);
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
