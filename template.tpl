﻿___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "APPRL",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Add the APPRL tag to the site. Functionality includes remarketing and conversion tracking capabilities.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "tagType",
    "displayName": "Tag type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "retargeting",
        "displayValue": "Retargeting"
      },
      {
        "value": "conversion",
        "displayValue": "Conversion"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "orderParams",
    "displayName": "Required Conversion Parameters",
    "simpleTableColumns": [
      {
        "defaultValue": "order_id",
        "displayName": "Parameter Name",
        "name": "name",
        "type": "SELECT",
        "selectItems": [
          {
            "value": "order_id",
            "displayValue": "order_id"
          },
          {
            "value": "order_value",
            "displayValue": "order_value"
          },
          {
            "value": "currency",
            "displayValue": "currency"
          }
        ],
        "isUnique": true
      },
      {
        "defaultValue": "",
        "displayName": "Parameter Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ],
    "newRowButtonText": "Add Parameter"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "productParams",
    "displayName": "Optional Conversion Parameters",
    "simpleTableColumns": [
      {
        "defaultValue": "sku",
        "displayName": "Parameter Name",
        "name": "name",
        "type": "SELECT",
        "selectItems": [
          {
            "value": "sku",
            "displayValue": "sku"
          },
          {
            "value": "quantity",
            "displayValue": "quantity"
          },
          {
            "value": "price",
            "displayValue": "price"
          }
        ],
        "isUnique": true
      },
      {
        "defaultValue": "",
        "displayName": "Parameter Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ],
    "newRowButtonText": "Add Parameter"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');
const makeTableMap = require('makeTableMap');
const log = require('logToConsole');

const fail = msg => {
  log('[APPRL] ' + msg);
  return data.gtmOnFailure();
};

const runConversion = () => {
  // Check that APPRL has been generated by library, fail if not.
  if (!copyFromWindow('APPRL')) {
    return fail('Unable to initialize the APPRL library.');
  }
  // Parse order (required) and product (optional) parameters into format expected by APPRL.Tracking.Sale
  const orderParams = data.orderParams ? makeTableMap(data.orderParams, 'name', 'value') : {};
  const productParams = data.productParams ? makeTableMap(data.productParams, 'name', 'value') : {};
  if (!orderParams.order_id) return fail('"order_id" missing from order parameters.');
  if (!orderParams.order_value) return fail('"order_value" missing from order parameters.');
  if (!orderParams.currency) return fail('"currency" missing from order parameters.');
  const saleObject = {
    order_id: orderParams.order_id,
    order_value: orderParams.order_value,
    currency: orderParams.currency
  };
  if (productParams.price) saleObject.price = productParams.price;
  if (productParams.sku) saleObject.sku = productParams.sku;
  if (productParams.quantity) saleObject.quantity = productParams.quantity;
  // Set the parameters into the object
  setInWindow('APPRL.Tracking.Sale', saleObject, true);
  // Call the .submitSale() method to send the data to APPRL
  callInWindow('APPRL.Tracking.submitSale');

  data.gtmOnSuccess();
};

injectScript('https://s.apprl.com/js/apprl.js', () => {
  // For retargeting, only inject the library
  if (data.tagType === 'retargeting') { 
    data.gtmOnSuccess();
  } else {
    // For the conversion tag, process the conversion data and send it to APPRL
    runConversion();
  }
}, data.gtmOnFailure, 'APPRL');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "APPRL"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "APPRL.Tracking.Sale"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "APPRL.Tracking.submitSale"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://s.apprl.com/js/apprl.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Library is injected
  code: |-
    mockData.tagType = 'retargeting';

    runCode(mockData);

    assertApi('copyFromWindow').wasNotCalled();
    assertApi('injectScript').wasCalledWith('https://s.apprl.com/js/apprl.js', success, failure, 'APPRL');
    assertApi('gtmOnSuccess').wasCalled();
- name: Tag fails if APPRL not initialized for conversion
  code: |-
    mockData.tagType = 'conversion';

    mock('copyFromWindow', key => {
      if (key === 'APPRL') return;
      fail('copyFromWindow called for something other than APPRL');
    });

    runCode(mockData);

    assertApi('copyFromWindow').wasCalledWith('APPRL');
    assertApi('gtmOnSuccess').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
- name: Conversion added correctly to APPRL
  code: |-
    const makeTableMap = require('makeTableMap');

    const orderParsed = makeTableMap(mockData.orderParams, 'name', 'value');
    const productParsed = makeTableMap(mockData.productParams, 'name', 'value');

    const expected = {};

    for (let key in orderParsed) expected[key] = orderParsed[key];
    for (let key in productParsed) expected[key] = productParsed[key];

    mockData.tagType = 'conversion';

    mock('copyFromWindow', key => {
      if (key === 'APPRL') return true;
      fail('copyFromWindow called for something other than APPRL');
    });

    mock('setInWindow', (key, arg1, arg2) => {
      if (key === 'APPRL.Tracking.Sale') {
        assertThat(arg1, 'setInWindow called with invalid object').isEqualTo(expected);
        assertThat(arg2, 'setInWindow called with invalid boolean').isEqualTo(true);
        return;
      }
      fail('setInWindow called for something other than APPRL.Tracking.Sale');
    });

    mock('callInWindow', key => {
      if (key === 'APPRL.Tracking.submitSale') return;
      fail('callInWindow called for something other than APPRL.Tracking.submitSale');
    });

    runCode(mockData);

    assertApi('copyFromWindow').wasCalledWith('APPRL');
    assertApi('setInWindow').wasCalledWith('APPRL.Tracking.Sale', expected, true);
    assertApi('callInWindow').wasCalledWith('APPRL.Tracking.submitSale');
    assertApi('gtmOnSuccess').wasCalled();
setup: |-
  const mockData = {
    orderParams: [{
      name: 'order_id',
      value: 'id_test'
    },{
      name: 'order_value',
      value: 'value_test'
    },{
      name: 'currency',
      value: 'currency_test'
    }],
    productParams: [{
      name: 'sku',
      value: 'sku_test'
    },{
      name: 'quantity',
      value: 'quantity_test'
    },{
      name: 'currency',
      value: 'currency_test'
    }]
  };

  let success, failure;
  mock('injectScript', (url, onsuccess, onfailure, str) => {
    assertThat(url, 'injectScript called with invalid url').isEqualTo('https://s.apprl.com/js/apprl.js');
    assertThat(str, 'injectScript called with invalid string parameter').isEqualTo('APPRL');
    success = onsuccess;
    failure = onfailure;
    onsuccess();
  });


___NOTES___

Created on 07/05/2020, 12:24:36


