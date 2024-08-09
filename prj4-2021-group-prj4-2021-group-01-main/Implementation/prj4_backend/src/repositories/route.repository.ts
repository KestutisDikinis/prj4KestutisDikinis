import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {Route, RouteRelations} from '../models';

export class RouteRepository extends DefaultCrudRepository<
  Route,
  typeof Route.prototype.ID,
  RouteRelations
> {
  constructor(
    @inject('datasources.db') dataSource: DbDataSource,
  ) {
    super(Route, dataSource);
  }
}
