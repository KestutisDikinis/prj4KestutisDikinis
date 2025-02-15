import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
  response,
} from '@loopback/rest';
import {Route} from '../models';
import {RouteRepository} from '../repositories';

export class RouteControllerController {
  constructor(
    @repository(RouteRepository)
    public routeRepository : RouteRepository,
  ) {}

  @post('/routes')
  @response(200, {
    description: 'Route model instance',
    content: {'application/json': {schema: getModelSchemaRef(Route)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Route, {
            title: 'NewRoute',
            exclude: ['ID'],
          }),
        },
      },
    })
    route: Omit<Route, 'ID'>,
  ): Promise<Route> {
    return this.routeRepository.create(route);
  }

  @get('/routes/count')
  @response(200, {
    description: 'Route model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Route) where?: Where<Route>,
  ): Promise<Count> {
    return this.routeRepository.count(where);
  }

  @get('/routes')
  @response(200, {
    description: 'Array of Route model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Route, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Route) filter?: Filter<Route>,
  ): Promise<Route[]> {
    return this.routeRepository.find(filter);
  }

  @patch('/routes')
  @response(200, {
    description: 'Route PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Route, {partial: true}),
        },
      },
    })
    route: Route,
    @param.where(Route) where?: Where<Route>,
  ): Promise<Count> {
    return this.routeRepository.updateAll(route, where);
  }

  @get('/routes/{id}')
  @response(200, {
    description: 'Route model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Route, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(Route, {exclude: 'where'}) filter?: FilterExcludingWhere<Route>
  ): Promise<Route> {
    return this.routeRepository.findById(id, filter);
  }

  @get('/routeByName/{name}')
  @response(200,{
    description: 'Route model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Route, {includeRelations: true}),
      },
    },
  })
  async findByName(
      @param.path.string('name') name: String,
      @param.filter(Route, {exclude: 'where'}) filter?: FilterExcludingWhere<Route>
  ): Promise<Route>{
    // @ts-ignore
    return this.routeRepository.findOne(name, filter);
  }

  @patch('/routes/{id}')
  @response(204, {
    description: 'Route PATCH success',
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Route, {partial: true}),
        },
      },
    })
    route: Route,
  ): Promise<void> {
    await this.routeRepository.updateById(id, route);
  }

  @put('/routes/{id}')
  @response(204, {
    description: 'Route PUT success',
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() route: Route,
  ): Promise<void> {
    await this.routeRepository.replaceById(id, route);
  }

  @del('/routes/{id}')
  @response(204, {
    description: 'Route DELETE success',
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.routeRepository.deleteById(id);
  }
}
