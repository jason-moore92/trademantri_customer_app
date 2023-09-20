class AppConfig {
  static double mobileDesignWidth = 411.43;
  static double mobileDesignHeight = 813.43;
  static double mobilePixelRatio = 2.625;

  // support
  static String appStoreLink = "https://www.apple.com/app-store/";
  static String playStoreLink = "https://play.google.com/store/apps/details?id=com.tradilligence.TradeMantri";

  static String disclaimerDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-DISCLAIMER.pdf";
  static String privacyDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-PRIVACY+POLICY.pdf";
  static String termsDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-Terms%26Conditions.pdf";

  static double companyLatitude = 17.4520399;
  static double companyLongitude = 78.3894064;
  static String supportEmail = "info@trademantri.com";
  static String companyName = "TradeMantri";
  static String companyAddress = "Quixtart Business Center , 4th Floor, Plot 532 100 Feet Road, Ayyappa Society";
  static String companyArea = "Madhapur";
  static String companyCity = "Hyderabad";
  static String companyState = "Telangana";
  static String companyZip = "500081";
  //////////////////////////////////////////////////

  ///
  static int supportRepeatCount = 3;
  static const int countLimitForList = 10;
  static String storeType = "Retailer,Wholesaler,Service";
  static int deliveryDistance = 10;
  static int deliveryDistanceLimit = 75;
  static List<dynamic> distances = [
    {"text": "5Kms", "value": 5},
    {"text": "10Kms", "value": 10},
    {"text": "20Kms", "value": 20},
    {"text": "25Kms", "value": 25},
    {"text": "50Kms", "value": 50}
  ];
  static List<String> deliveryAddressType = ["Home", "Office", "Others"];
  static List<dynamic> tipData = ["no", 5, 7, 10, 15, 20, 25, "Custom"];
  // static Map<String, dynamic> deliveryPrice = {
  //   "initialDistance": 6,
  //   "initialPrice": 40,
  //   "additionalDistance": 0.2,
  //   "additionalPrice": 1,
  // };

  // static Map<String, dynamic> orderCategories = {
  //   "Cart": "Cart",
  //   "AssistantCheckout": "TM Assistant",
  // };

  static List<dynamic> orderStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "order_placed", "name": "Order Placed"},
    {"id": "order_accepted", "name": "Accepted"},
    {"id": "order_paid", "name": "Paid"},
    {"id": "pickup_ready", "name": "PickUp ready"},
    {"id": "delivery_ready", "name": "Delivery ready"},
    {"id": "delivered", "name": "Delivered"},
    {"id": "order_cancelled", "name": "Cancelled"},
    {"id": "order_rejected", "name": "Rejected"},
    {"id": "order_completed", "name": "Completed"},
  ];

  static List<dynamic> bargainRequestStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "requested", "name": "Requested"},
    {"id": "counter_offer", "name": "Counter Offer"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "completed", "name": "Completed"},
    {"id": "rejected", "name": "Rejected"},
    {"id": "cancelled", "name": "Cancelled"},
  ];

  static List<dynamic> bargainSubStatusData = [
    {"id": "new_requested", "name": "New Requested"},
    {"id": "user_counter_offer", "name": "User Counter Offer"},
    {"id": "store_count_offer", "name": "Store Counter Offer"},
  ];

  static List<dynamic> reverseAuctionStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "requested", "name": "Bid Request"},
    {"id": "store_offer", "name": "Store Offer"},
    {"id": "cancelled", "name": "Cancelled"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "past", "name": "Old Auctions"},
  ];

  static Map<String, dynamic> bargainHistoryData = {
    "requested": {
      "title": "New Bargain Request",
      "text": "A new bargain request has been made by userName to the store storeName",
    },
    "store_count_offer": {
      "title": "Counter offer from store",
      "text": "A counter offer has been made by store storeName to the userName bargain request",
    },
    "user_counter_offer": {
      "title": "Counter offer from User",
      "text": "A counter bargain request has been made by userName to the store storeName",
    },
    "accepted": {
      "title": "Bargain Request accepted",
      "text": "This bargian request was accepted by store storeName",
    },
    "rejected": {
      "title": "Bargain Request rejected",
      "text": "This bargian request was rejected by store storeName",
    },
    "cancelled": {
      "title": "Bargain Request cancelled",
      "text": "This bargian request was cancelled by userName",
    },
    "completed": {
      "title": "Bargain Request completed",
      "text": "This bargian request was completed by userName",
    }
  };

  static Map<String, dynamic> notificationStatusData = {
    "action": "Action",
    "bargain": "Bargain",
    "chats": "Chats",
    "discounts": "Discounts",
    "jobs": "Jobs",
    "order": "Order",
    "profile": "Profile",
    "reward_points": "Reward Points",
  };

  static String encryptKeyString = "	Ïx_ü6H1Ãjº¤_ã«";

  static List<dynamic> taxValues = [
    {"text": "No Tax", "value": 0},
    {"text": "5%", "value": 5},
    {"text": "12%", "value": 12},
    {"text": "18%", "value": 18},
    {"text": "28%", "value": 28}
  ];

  static Map<String, dynamic> initialSettings = {
    "notification": true,
    "bargainEnable": true,
    "bargainOfferPricePercent": 40.0,
  };

  static List<dynamic> orderDataFilter = [
    {"text": "Day", "value": "day"},
    {"text": "Week", "value": "week"},
    {"text": "Month", "value": "month"},
  ];

  static Map<String, dynamic> orderCategories = {
    "cart": "Cart",
    "assistant": "Assistant",
    "reverse_auction": "Reverse Auction",
    "bargain": "Bargain",
  };

  static Map<String, dynamic> deliveryOrderHistory = {
    "delivery_assigned": {
      "title": "Accepted",
      "desc": "Order accepted by delivery_user_name",
    },
    "delivery_cancelled": {
      "title": "Delivery Cancelled By Delivery Person",
      "desc": "Your store order orderId is cancelled for delivery by delivery_user_name",
    },
    "sent_delivery_pickup_code": {
      "title": "Items picked up from store",
      "desc": "The items belonging to order orderId have been picked up from store by delivery_user_name",
    },
    "delivery_pickup_completed": {
      "title": "Items picked up from store",
      "desc": "The items belonging to order orderId have been picked up from store by delivery_user_name",
    },
    "sent_delivery_complete_code": {
      "title": "Code to Confirm Delivery",
      "desc": "To confirm items delivered to you, please tell this code customerDeliveryCode to the delivery person delivery_user_name",
    },
    "items_delivery_complete": {
      "title": "Items Delivery Completed",
      "desc": "Items have been successfully delivered from store_name to user_name by delivery person delivery_person_name",
    },
    "delivery_complete": {
      "title": "Delivery Completed",
      "desc":
          "Items have been successfully delivered from store_name to user_name by delivery person delivery_person_name. The delivery for the order orderId is now completed",
    },
    "payment_received": {
      "title": "Payment Received",
      "desc":
          "The payment has been received by delivery person delivery_person_name from customer user_name. The delivery for the order orderId is now completed",
    },
  };

  static List<dynamic> salaryType = [
    {"text": "Hourly", "value": "Hourly"},
    {"text": "Daily", "value": "Daily"},
    {"text": "Weekly", "value": "Weekly"},
    {"text": "Monthly", "value": "Monthly"},
    {"text": "Yearly", "value": "Yearly"},
  ];

  static List<dynamic> jobStatusType = [
    {"text": "Open", "value": "open"},
    {"text": "Paused", "value": "paused"},
    {"text": "Closed", "value": "closed"},
  ];

  static List<dynamic> appliedJobStatusType = [
    {"text": "Applied", "id": "applied"},
  ];

  static List<dynamic> appliedJobApprovalStatusType = [
    {"text": "Not Viewed", "id": ""},
    {"text": "Viewed", "id": "viewed"},
    {"text": "Accepted", "id": "accepted"},
    {"text": "Rejected", "id": "rejected"},
  ];

  static Map<String, dynamic> discountTypeImages = {
    "PERCENTAGE": "img/coupons/percentage.png",
    "FIXED_AMOUNT": "img/coupons/fixed.png",
    "BOGO": "img/coupons/bogo.png",
  };

  static Map<String, dynamic> discountTypeImages1 = {
    "PERCENTAGE": "img/coupons/percentage1.png",
    "FIXED_AMOUNT": "img/coupons/fixed1.png",
    "BOGO": "img/coupons/bogo1.png",
  };

  static Map<String, dynamic> promoCodeTypeImages = {
    "Percentage": "img/promocodes/percentage.png",
    "INR(Rupees)": "img/promocodes/fixed.png",
    "Delivery": "img/promocodes/delivery.png",
  };

  static List<dynamic> promoCodeTypes = [
    {"text": "Percentage", "value": "Percentage"},
    {"text": "INR(Rupees)", "value": "INR(Rupees)"},
    {"text": "Delivery", "value": "Delivery"},
  ];

  static List<dynamic> discountTypeForCoupon = [
    {"text": "Percentage", "value": "PERCENTAGE"},
    {"text": "Fixed amount", "value": "FIXED_AMOUNT"},
    // {"text": "Free Shipping", "value": "Free Shipping"},
    {"text": "Buy X Get Y", "value": "BOGO"},
  ];

  static List<dynamic> discountBuyValueForCoupon = [
    {"text": "Free", "value": "Free"},
    {"text": "Percentage", "value": "Percentage"},
  ];

  // static List<dynamic> customerEligibilityForCoupon = [
  //   {"text": "Everyone", "value": "Everyone"},
  //   {"text": "Specific Customers", "value": "Specific_Customers"},
  // ];

  static List<dynamic> eligibilityForCoupon = [
    {"text": "Customer coupon", "value": "for_customer"},
    {"text": "Business B2B coupon", "value": "for_business"},
  ];

  static List<dynamic> usageLimitsForCoupon = [
    {"text": "Unlimited", "value": "Unlimited"},
    {"text": "Limit number of times this discount can be used in total", "value": "Number_Limit"},
    {"text": "Limit to one use per customer", "value": "One_Per_Customer"},
  ];

  static List<dynamic> appliesToForCoupon = [
    {"text": "Entire Order", "value": "Entire_Order"},
    {"text": "Specific Categories", "value": "Categories"},
    {"text": "Specific Products", "value": "Items"},
  ];

  static List<dynamic> announcementImage = [
    "https://tm-announcements-bucket.s3.ap-south-1.amazonaws.com/announcements/announcements-default.png",
  ];

  static List<dynamic> announcementTo = [
    {"text": "Post to All Customers", "value": "CUSTOMERS_ONLY"},
    {"text": "Post to All Business", "value": "BUSINESS_ONLY"},
    // {"text": "Post to All Business & Customers", "value": "BUSINESSES_AND_CUSTOMERS"},
  ];

  static List<dynamic> announcmentType = [
    {"value": "BASIC"},
    {"value": "BASIC_WITH_COUPON"}
  ];

  static List<dynamic> minRequirementsForCoupon = [
    {"text": "None", "value": "None"},
    {"text": "Minimum purchase amount", "value": "Purchase_Amount"},
    {"text": "Minimum quantity", "value": "Purchase_Quantity"},
  ];

  static List<dynamic> bookAppointmentStatus = [
    {"id": "all", "name": "ALL"},
    // {"id": "created", "name": "Created"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "rejected", "name": "Rejected"},
    {"id": "cancelled", "name": "Cancelled"},
    {"id": "past", "name": "Past"},
  ];

  static List<Map<String, dynamic>> paymentMethods = [
    {
      "name": "UPI",
      "value": "icici_upi",
      "image": "bhim_upi",
    },
    {
      "name": "Razorpay",
      "value": "razorpay",
      "image": "razorpay",
    }
  ];
}
