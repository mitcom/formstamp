mod = require('./module')

require('../styles/racheck.less')
u = require('./utils')
require('../templates/metaCheckbox.html')

mod.directive "fsCheckbox", ['$templateCache', ($templateCache) ->
    restrict: "A"
    scope:
      disabled: '=ngDisabled'
      required: '='
      errors: '='
      items: '='
      inline: '='
    require: '?ngModel'
    replace: true
    template: (el, attrs)->
      itemTpl = el.html() || 'template me: {{item | json}}'

      $templateCache.get('templates/fs/metaCheckbox.html')
        .replace(/::itemTpl/g, itemTpl)

    controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
      $scope.toggle = (item)->
        return if $scope.disabled
        unless $scope.isSelected(item)
          $scope.selectedItems.push(item)
        else
          $scope.selectedItems.splice(u.indexOf($scope.selectedItems, item), 1)
        false

      $scope.isSelected = (item) -> u.indexOf($scope.selectedItems, item) > -1

      $scope.invalid = -> $scope.errors? and $scope.errors.length > 0

      $scope.selectedItems = []
    ]

    link: (scope, element, attrs, ngModelCtrl, transcludeFn) ->
        if ngModelCtrl
          setViewValue = (newValue, oldValue)->
            unless angular.equals(newValue, oldValue)
              ngModelCtrl.$setViewValue(scope.selectedItems)

          scope.$watch 'selectedItems', setViewValue, true

          ngModelCtrl.$render = ->
            unless scope.disabled
              scope.selectedItems = ngModelCtrl.$viewValue || []
]
